# typed: false
# frozen_string_literal: true

TaskRequest =
  Struct.new(
    :name,
    :context,
    :status,
    :initiator,
    :source_system,
    :reason,
    :complete,
    :tags,
    :bypass_steps,
    :requested_at
  ) do
    def initialize(options)
      options.each do |key, value|
        __send__("#{key}=".to_sym, value) if value.present?
      end
      self.status ||= Constants::TaskStatuses::PENDING
      self.requested_at ||= Time.zone.now
      self.initiator ||= Constants::UNKNOWN
      self.source_system ||= Constants::UNKNOWN
      self.reason ||= Constants::UNKNOWN
      self.complete ||= false
      self.tags ||= []
      self.bypass_steps ||= []
    end
  end
