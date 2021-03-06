# typed: false
# frozen_string_literal: true

StepTemplate =
  Struct.new(
    :dependent_system,
    :name,
    :description,
    :default_retryable,
    :default_retry_limit,
    :skippable,
    :depends_on_step,
    :handler_class
  ) do
    def initialize(options)
      options.each do |key, value|
        __send__("#{key}=".to_sym, value) if value.present?
      end
      self.default_retry_limit ||= 3
      self.default_retryable ||= true
      self.skippable ||= false
    end
  end
