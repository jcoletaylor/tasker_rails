# frozen_string_literal: true

# == Schema Information
#
# Table name: named_tasks_named_steps
#
#  id                  :integer          not null, primary key
#  default_retry_limit :integer          default(3), not null
#  default_retryable   :boolean          default(TRUE), not null
#  skippable           :boolean          default(FALSE), not null
#  named_step_id       :integer          not null
#  named_task_id       :integer          not null
#
# Indexes
#
#  named_tasks_named_steps_named_step_id_index  (named_step_id)
#  named_tasks_named_steps_named_task_id_index  (named_task_id)
#  named_tasks_steps_ids_unique                 (named_task_id,named_step_id) UNIQUE
#
# Foreign Keys
#
#  named_tasks_named_steps_named_step_id_foreign  (named_step_id => named_steps.named_step_id)
#  named_tasks_named_steps_named_task_id_foreign  (named_task_id => named_tasks.named_task_id)
#
class NamedTasksNamedStep < ApplicationRecord
  belongs_to :named_task
  belongs_to :named_step
  validates :named_task_id, presence: true, uniqueness: { scope: :named_step_id }
  validates :named_step_id, presence: true, uniqueness: { scope: :named_task_id }

  def self.find_or_create(
    named_task,
    named_step,
    options = {
      default_retry_limit: 3,
      default_retryable: true,
      skippable: false
    }
  )
    inst = where(named_task_id: named_task.named_task_id, named_step_id: named_step.named_step_id).first

    inst ||= create({ named_task_id: named_task.named_task_id, named_step_id: named_step.named_step_id }.merge(options))

    inst
  end
end
