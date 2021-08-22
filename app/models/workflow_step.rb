# frozen_string_literal: true

# == Schema Information
#
# Table name: workflow_steps
#
#  attempts                :integer
#  backoff_request_seconds :integer
#  in_process              :boolean          default(FALSE), not null
#  inputs                  :jsonb
#  last_attempted_at       :datetime
#  processed               :boolean          default(FALSE), not null
#  processed_at            :datetime
#  results                 :jsonb
#  retry_limit             :integer          default(3)
#  retryable               :boolean          default(TRUE), not null
#  status                  :string(64)       not null
#  depends_on_step_id      :bigint
#  named_step_id           :integer          not null
#  task_id                 :bigint           not null
#  workflow_step_id        :bigint           not null, primary key
#
# Indexes
#
#  workflow_steps_depends_on_step_id_index  (depends_on_step_id)
#  workflow_steps_last_attempted_at_index   (last_attempted_at)
#  workflow_steps_named_step_id_index       (named_step_id)
#  workflow_steps_processed_at_index        (processed_at)
#  workflow_steps_status_index              (status)
#  workflow_steps_task_id_index             (task_id)
#
# Foreign Keys
#
#  workflow_steps_depends_on_step_id_foreign  (depends_on_step_id => workflow_steps.workflow_step_id)
#  workflow_steps_named_step_id_foreign       (named_step_id => named_steps.named_step_id)
#  workflow_steps_task_id_foreign             (task_id => tasks.task_id)
#
class WorkflowStep < ApplicationRecord
  self.primary_key = :workflow_step_id
  belongs_to :task
  belongs_to :named_step
  belongs_to :depends_on_step, class_name: 'WorkflowStep'

  validates :task_id, presence: true
  validates :named_step_id, presence: true

  def self.get_steps_for_task(task, templates)
    named_steps = create_named_steps_from_templates(templates)
    steps =
      templates.map do |template|
        named_step = named_steps.find { |ns| template.name == ns.name }
        step_for_task = associate_named_step_with_named_task(task, template, named_step)
        step = where(task_id: task.task_id, named_step_id: named_step.named_step_id).first
        step ||= build_default_step!(task, step_for_task)
        step
      end
    steps = set_up_dependent_steps(steps, templates)
    steps
  end

  def self.associate_named_step_with_named_task(task, template, named_step)
    # TODO: find all the defaults for systems and named actions
    # and return a step_for_task here
  end

  def self.set_up_dependent_steps(steps, templates)
    templates.each do |template|
      next unless template.depends_on_step

      dependent_step = steps.find { |step| step.name == template.name }
      depends_on_step = steps.find { |step| step.name == template.depends_on_step }
      dependent_step.depends_on_step_id = depends_on_step.workflow_step_id
      dependent_step.save
    end
    steps
  end

  def self.build_default_step!(task, named_step)
    create!(
      {
        task_id: task.task_id,
        named_step_id: named_step.named_step_id,
        status: Constants::WorkflowStepStatuses::PENDING,
        retryable: named_step.default_retryable,
        retry_limit: named_step.default_retry_limit,
        in_process: false,
        inputs: action.context,
        processed: false,
        attempts: 0
      }
    )
  end

  def self.create_named_steps_from_templates(templates)
    named_steps =
      templates.map do |template|
        dependent_system = DependentSystem.find_or_create_by!(name: template.dependent_system)
        named_step = NamedStep.find_or_create_by!(name: template.name, dependent_system_id: dependent_system.dependent_system_id)
        named_step
      end
    named_steps
  end
end
