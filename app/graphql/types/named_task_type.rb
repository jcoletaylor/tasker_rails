# typed: strict
# frozen_string_literal: true

module Types
  class NamedTaskType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :description, String, null: true
    field :name, String, null: false
    field :named_task_id, ID, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
