# frozen_string_literal: true

class DummyTask
  include TaskHandlers::HandlerCommon
  DUMMY_SYSTEM = 'dummy-system'
  STEP_ONE = 'step-one'
  STEP_TWO = 'step-two'
  STEP_THREE = 'step-three'
  STEP_FOUR = 'step-four'
  ANNOTATION_TYPE = 'dummy-annotation'
  TASK_REGISTRY_NAME = 'dummy_task'

  class Handler
    def handle(_task, _sequence, step)
      step.results = { dummy: true }
    end
  end

  def update_annotations(task, _sequence, steps)
    annotatable_steps = steps.filter { |step| step.status == Constants::WorkflowStepStatuses::COMPLETE }
    annotatable_steps.each do |step|
      annotation_type = AnnotationType.find_or_create_by!(name: ANNOTATION_TYPE)
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
        description: 'Step Three Dependent on Step Two',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::Handler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_FOUR,
        depends_on_step: STEP_THREE,
        description: 'Step Four Dependent on Step Three',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::Handler
      )
    ]
  end
end

TaskHandlers::HandlerFactory.instance.register(DummyTask::TASK_REGISTRY_NAME, 'DummyTask')
