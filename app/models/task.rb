# frozen_string_literal: true

require 'digest'
# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  bypass_steps  :json
#  complete      :boolean          default(FALSE), not null
#  context       :jsonb
#  identity_hash :string(128)      not null
#  initiator     :string(128)
#  reason        :string(128)
#  requested_at  :datetime         not null
#  source_system :string(128)
#  status        :string(64)       not null
#  tags          :jsonb
#  named_task_id :integer          not null
#  task_id       :bigint           not null, primary key
#
# Indexes
#
#  tasks_context_idx          (context) USING gin
#  tasks_context_idx1         (context) USING gin
#  tasks_identity_hash_index  (identity_hash)
#  tasks_named_task_id_index  (named_task_id)
#  tasks_requested_at_index   (requested_at)
#  tasks_source_system_index  (source_system)
#  tasks_status_index         (status)
#  tasks_tags_idx             (tags) USING gin
#  tasks_tags_idx1            (tags) USING gin
#
# Foreign Keys
#
#  tasks_named_task_id_foreign  (named_task_id => named_tasks.named_task_id)
#
class Task < ApplicationRecord
  self.primary_key =  :task_id
  belongs_to :named_task

  validates :named_task_id, presence: true
  validates :context, presence: true
  validates :identity_hash, presence: true
  validates :requested_at, presence: true
  validates :status, presence: true
  validate :unique_identity_hash

  delegate :name, to: :named_task

  private

  def unique_identity_hash
    opt_string = identity_options.to_json
    self.identity_hash ||= Digest::SHA256.hexdigest(opt_string)
    alt_inst = self.class.where(identity_hash: identity_hash).first
    errors.add(:identity_hash, 'has already been used') if alt_inst
  end

  def identity_options
    {
      name: name,
      initiator: initiator || 'unknown',
      source_system: source_system || 'unknown',
      context: context,
      reason: reason || 'unknown',
      bypass_steps: bypass_steps || []
    }
  end
end
