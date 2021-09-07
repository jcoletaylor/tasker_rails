# typed: true
# frozen_string_literal: true

StepSequence =
  Struct.new(:steps) do
    def initialize(options)
      options.each do |key, value|
        __send__("#{key}=".to_sym, value) if value.present?
      end
      self.steps ||= []
    end
  end
