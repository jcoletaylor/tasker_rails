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
#  skippable               :boolean          default(FALSE), not null
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
require 'rails_helper'

RSpec.describe WorkflowStep, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
