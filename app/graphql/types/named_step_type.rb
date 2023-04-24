# typed: strict
# frozen_string_literal: true

module Types
  class NamedStepType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :dependent_system, Types::DependentSystemType, null: true
    field :dependent_system_id, Integer, null: false
    field :description, String, null: true
    field :name, String, null: false
    field :named_step_id, ID, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
