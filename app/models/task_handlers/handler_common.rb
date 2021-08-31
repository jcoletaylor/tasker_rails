# frozen_string_literal: true

module TaskHandlers
  module HandlerCommon
    attr_accessor :step_handler_class_map, :step_templates

    def initialize
      # NOTE: this relies on super being called
      # or classes where this is included calling
      # the register methods themselves
      register_step_templates
      register_step_handler_classes
    end

    def initialize_task!(requested_task)
      rq = requested_task.dup
      task_name = rq.delete(:name)
      context = rq.delete(:context)
      task = nil
      Task.transaction do
        task = Task.create_with_defaults!(task_name, context, rq)
        get_sequence(task)
      end
      enqueue_task(task)
      task
    end

    def get_sequence(task)
      steps = WorkflowStep.get_steps_for_task(task, step_templates)
      establish_step_dependencies_and_defaults(task, steps)
      StepSequence.new(steps: steps)
    end

    def start_task(task)
      raise TaskHandlers::ProceduralError, "task already complete for task #{task.task_id}" if task.complete

      raise TaskHandlers::ProceduralError, "task is not pending for task #{task.task_id}, status is #{task.status}" unless task.status == Constants::TaskStatuses::PENDING

      # I don't need to re-run the validations here
      task.update_attribute(:status, Constants::TaskStatuses::IN_PROGRESS)
    end

    def handle(task)
      start_task(task)
      sequence = get_sequence(task)
      viable_steps = WorkflowStep.get_viable_steps(task, sequence)
      steps = handle_viable_steps(task, sequence, viable_steps)
      # get sequence again, updated
      sequence = get_sequence(task)
      more_viable_steps = WorkflowStep.get_viable_steps(task, sequence)
      if more_viable_steps.length.positive?
        # I don't need to re-run the validations here
        task.update_attribute(:status, Constants::TaskStatuses::PENDING)
        # if there are more viable steps that we can handle now
        # that we are not waiting on, then just recursively call handle again
        handle(task)
      end
      finalize(task, sequence, steps)
    end

    def handle_one_step(task, sequence, step)
      handler = get_step_handler(step)
      attempts = step.attempts || 0
      begin
        handler.handle(task, sequence, step)
        step.processed = true
        step.processed_at = Time.zone.now
        step.status = Constants::WorkflowStepStatuses::COMPLETE
      rescue StandardError => e
        step.processed = false
        step.processed_at = nil
        step.status = Constants::WorkflowStepStatuses::ERROR
        step.results = { error: e.to_s }
      end
      step.attempts = attempts + 1
      step.last_attempted_at = Time.zone.now
      step.save!
      step
    end

    def handle_viable_steps(task, sequence, steps)
      steps.each do |step|
        handle_one_step(task, sequence, step)
      end
      # we can update annotations in every pass
      update_annotations(task, sequence, steps)
      steps
    end

    # this is a long method, there's no real way around it
    # we are finalizing whether a task is complete
    # whether it is in error, or whether we can still retry it
    # or whether no errors exist but if we should re-enqueue
    # if there are still valid workable steps
    # we could break it down into components, but I think it may be
    # harder to reason about
    def finalize(task, sequence, steps)
      # how many steps in this round are in an error state before, and based on
      # being processed in this round of handling, is it still in an error state
      error_steps = get_error_steps(steps, sequence)
      # if there are no steps in error still, then move on to the rest of the checks
      # if there are steps in error still, then we need to see if we have tried them
      # too many times - if we have, we need to mark the whole task as in error
      # if we have not, then we need to re-enqueue the task
      if error_steps.length.positive?
        too_many_attempts_steps =
          error_steps.filter do |err_step|
            return true if err_step.attempts.positive? && !err_step.retryable
            return true if err_step.attempts >= err_step.retry_limit
          end
        if too_many_attempts_steps.length.positive?
          task.update_attribute(:status, Constants::TaskStatuses::ERROR)
          return
        end
        task.update_attribute(:status, Constants::TaskStatuses::PENDING)
        enqueue_task(task)
        return
      end
      # determine which states were incomplete for the whole sequence before this round
      prior_incomplete_steps =
        sequence.steps.filter do |step|
          !Constants::VALID_STEP_COMPLETION_STATES.include?(step.status)
        end
      # if nothing was incomplete, set the task to complete and save, and return
      if prior_incomplete_steps.length.zero?
        task.update_attribute(:status, Constants::TaskStatuses::COMPLETE)
        return
      end
      # the steps that are passed into finalize are not the whole sequence
      # just what has been worked on in this pass, so we need to see what completed
      # in a valid state, and what has still to be done
      this_pass_complete_steps =
        steps.filter do |step|
          !Constants::VALID_STEP_COMPLETION_STATES.include?(step.status)
        end
      this_pass_complete_step_ids = this_pass_complete_steps.map(&:workflow_step_id)
      # what was incomplete from the prior pass that is still incopmlete now
      still_incomplete_steps =
        prior_incomplete_steps.filter do |step|
          !this_pass_complete_step_ids.include?(step.workflow_step_id)
        end
      # if nothing is still incomplete after this pass
      # mark the task complete, update it, and return
      if still_incomplete_steps.length.zero?
        task.update_attribute(:status, Constants::TaskStatuses::COMPLETE)
        return
      end
      # what is still working but in a valid, retryable state
      still_working_steps =
        still_incomplete_steps.filter do |step|
          Constants::VALID_STEP_STILL_WORKING_STATES.include?(step.status)
        end
      # if we have steps that still need to be completed and in valid states
      # set the status of the task back to pending, update it,
      # and re-enqueue the task for processing
      if still_working_steps.length.positive?
        task.update_attribute(:status, Constants::TaskStatuses::PENDING)
        enqueue_task(task)
        return
      end
      # if we reach the end and have not re-enqueued the task
      # then we mark it complete since none of the above proved true
      task.update_attribute(:status, Constants::TaskStatuses::COMPLETE)
      return
    end

    def register_step_handler_classes
      self.step_handler_class_map = {}
      step_templates.each do |template|
        step_handler_class_map[template.name] = template.handler_class.to_s
      end
    end

    def get_step_handler(step)
      raise TaskHandlers::ProceduralError, "No registered class for #{step.name}" unless step_handler_class_map[step.name]

      step_handler_class_map[step.name].to_s.camelize.constantize.new
    end

    def handle_unknown_step(task, _sequence, step)
      attempts = step.attempts || 0
      step.processed = false
      step.processed_at = nil
      step.results = { error: "Step: #{step.name} is unknown for Task: #{task.name}" }
      step.status = Constants::WorkflowStepStatuses::ERROR
      step.attempts = attempts + 1
      step.last_attempted_at = Time.zone.now
      step
    end

    def get_error_steps(steps, sequence)
      error_steps =
        sequence.steps.filter do |step|
          # if in the original sequence this was an error
          # we need to see if the updated steps are still in error
          if step.status == Constants::WorkflowStepStatuses::ERROR
            processed_step =
              steps.find do |s|
                s.workflow_step_id == step.workflow_step_id
              end
            # no updated step was found to change our mind
            # about whether it was in error before, so true, still in error
            return true unless processed_step

            # was the processed step in error still
            return processed_step.status == Constants::WorkflowStepStatuses::ERROR
          end
        end
      error_steps
    end

    def enqueue_task(task)
      TaskRunnerJob.perform_async(task.task_id)
    end

    # override in implementing class
    def establish_step_dependencies_and_defaults(task, steps); end

    # override in implementing class
    def update_annotations(task, sequence, steps); end

    # override in implementing class
    def register_step_templates
      self.step_templates = []
    end
  end
end
