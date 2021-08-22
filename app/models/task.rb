# frozen_string_literal: true

require 'digest'

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
  self.primary_key = :task_id
  after_initialize :init_defaults, if: :new_record?
  belongs_to :named_task

  validates :named_task_id, presence: true
  validates :context, presence: true
  validates :identity_hash, presence: true
  validates :requested_at, presence: true
  validates :status, presence: true, inclusion: { in: Constants::VALID_TASK_STATUSES }
  validate :unique_identity_hash
  before_validation :set_identity_hash

  delegate :name, to: :named_task

  def self.create_with_defaults!(
    task_name,
    context,
    status = Constants::TaskStatuses::PENDING,
    initiator = Constants::UNKNOWN,
    source_system = Constants::UNKNOWN,
    reason = Constants::UNKNOWN,
    complete = false,
    tags = [],
    bypass_steps = [],
    requested_at = Time.zone.now
  )
    named_task = NamedTask.find_or_create_by!(name: task_name)
    inst = create!(
      named_task: named_task,
      named_task_id: named_task.named_task_id,
      status: status,
      initiator: initiator,
      source_system: source_system,
      context: context,
      reason: reason,
      bypass_steps: bypass_steps,
      requested_at: requested_at,
      complete: complete,
      tags: tags
    )
    inst
  end

  private

  def unique_identity_hash
    set_identity_hash
    inst = self.class.where(identity_hash: identity_hash).where.not(task_id: task_id).first
    errors.add(:identity_hash, 'is identical to a request made in the last minute') if inst
  end

  def identity_options
    # a task can be described as identical to a prior request if
    # it has the same name, initiator, source system, reason
    # bypass steps, and critically, the same identical context for the request
    # if all of these are the same, and it was requested within the same minute
    # then we can assume some client side or queue side duplication is happening
    {
      name: name,
      initiator: initiator,
      source_system: source_system,
      context: context,
      reason: reason,
      bypass_steps: bypass_steps || [],
      # not allowing structurally identical requests within the same minute
      # this is a fuzzy match of course, at the 59 / 00 mark there could be overlap
      # but this feels like a pretty good level of identity checking
      # without being exhaustive
      requested_at: requested_at.to_s(:date_hour_minute)
    }
  end

  def init_defaults
    return unless new_record?

    self.status ||= Constants::TaskStatuses::PENDING
    self.requested_at ||= Time.zone.now
    self.initiator ||= Constants::UNKNOWN
    self.source_system ||= Constants::UNKNOWN
    self.reason ||= Constants::UNKNOWN
    self.complete ||= false
    self.tags ||= []
    self.bypass_steps ||= []
  end

  def set_identity_hash
    self.identity_hash = Digest::SHA256.hexdigest(identity_options.to_json)
  end
end
