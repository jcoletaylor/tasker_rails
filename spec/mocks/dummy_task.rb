# typed: true
# frozen_string_literal: true

require 'dummy_rust_task_handler'
require 'rutie_task_handler'

class DummyTask
  include TaskHandlers::HandlerCommon
  DUMMY_SYSTEM = 'dummy-system'
  STEP_ONE = 'step-one'
  STEP_TWO = 'step-two'
  STEP_THREE = 'step-three'
  STEP_FOUR = 'step-four'
  STEP_FIVE = 'step-five'
  ANNOTATION_TYPE = 'dummy-annotation'
  TASK_REGISTRY_NAME = 'dummy_task'

  class Handler
    def handle(_task, _sequence, step)
      step.results = { dummy: true }
    end
  end

  class RustyHandler
    def handle(_task, _sequence, step)
      rusty_results = DummyRustTaskHandler::Handler.handle(step.inputs)
      step.results = rusty_results
    end
  end

  class RutieHandler
    def handle(task, sequence, step)
      rutie_step = DummyRutieTaskHandler.handle(task, sequence, step)
      step.results = rutie_step[:results]
    end
  end

  def schema
    @schema ||= { type: :object, required: [:dummy], properties: { dummy: { type: 'boolean' } } }
  end

  def update_annotations(task, _sequence, steps)
    annotatable_steps = steps.filter { |step| step.status == Constants::WorkflowStepStatuses::COMPLETE }
    annotation_type = AnnotationType.find_or_create_by!(name: ANNOTATION_TYPE)
    annotatable_steps.each do |step|
      TaskAnnotation.create(
        task: task,
        task_id: task.task_id,
        annotation_type_id: annotation_type.annotation_type_id,
        annotation_type: annotation_type,
        annotation: {
          dummy_annotation: 'something that might be important',
          step_name: step.name
        }
      )
    end
  end

  def register_step_templates
    self.step_templates = [
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_ONE,
        description: 'Independent Step One',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::Handler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_TWO,
        description: 'Independent Step Two',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::Handler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_THREE,
        depends_on_step: STEP_TWO,
        description: 'Step Three Dependent on Step Two using a Gem wrapping a Rutie handler',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::RutieHandler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_FOUR,
        depends_on_step: STEP_THREE,
        description: 'Step Four Dependent on Step Three using a Gem wrapping a Rust FFI',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::RustyHandler
      )
    ]
  end
end

TaskHandlers::HandlerFactory.instance.register(DummyTask::TASK_REGISTRY_NAME, DummyTask)
