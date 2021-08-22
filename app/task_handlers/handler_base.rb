# frozen_string_literal: true

module TaskHandlers
  class HandlerBase
    attr_accessor :step_handler_class_map

    def initialize
      register_step_templates
      register_step_handler_classes
    end

    def initialize_task(requested_task)
      Task.create_with_defaults!(
        requested_task[:task_name],
        requested_task[:context],
        requested_task[:status],
        requested_task[:initiator],
        requested_task[:source_system],
        requested_task[:reason],
        false,
        requested_task[:tags],
        requested_task[:bypass_steps]
      )
    end

    def get_sequence(task); end

    def begin(task)
      raise Errors::ProceduralError, "task already complete for #{task.task_id}" if task.complete

      raise Errors::ProceduralError, "task is not pending for #{task.task_id}, status is #{task.status}" unless task.status == Constants::TaskStatuses::PENDING

      task.update_attribute(:status, Constants::TaskStatuses::IN_PROGRESS)
    end

    def handle(task); end

    def handle_one_step(task, sequence, step)
      handler = get_step_handler_class(step)
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
      steps
    end

    def finalize(task, sequence, steps); end

    def register_step_handler_function_classes
      self.step_handler_class_map = {}
      step_templates.each do |template|
        step_handler_class_map[template.name] = template.handler_class
      end
    end

    def get_step_handler_class(step)
      raise Errors::ProceduralError, "No registered class for #{step.name}" unless step_handler_class_map[step.name]

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
          if step.status == Constants::WorkflowStepStatuses::ERROR
            processed_step =
              steps.find do |s|
                s.workflow_step_id == step.workflow_step_id
              end
            return true unless processed_step

            return true if processed_step.status == Constants::WorkflowStepStatuses::ERROR

            return false
          end
        end
      error_steps
    end

    def enqueue_task(task)
      # Use TaskRunnerJob here to send the task to Sidekiq
    end

    # override in sublcass
    def establish_step_dependencies_and_defaults(task, steps); end

    # override in subclass
    def update_annotations(action, sequence, steps); end

    # override in subclass
    def register_step_templates; end
  end
end
