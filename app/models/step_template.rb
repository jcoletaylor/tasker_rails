# frozen_string_literal: true

StepTemplate = Struct.new(
  :dependent_system,
  :name,
  :description,
  :default_retryable,
  :default_retry_limit,
  :skippable,
  :depends_on_step,
  :handler_class
)
