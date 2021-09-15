# typed: strict
# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :task_id, ID, null: false
    field :named_task_id, Integer, null: false
    field :status, String, null: false
    field :complete, Boolean, null: false
    field :requested_at, GraphQL::Types::ISO8601DateTime, null: false
    field :initiator, String, null: true
    field :source_system, String, null: true
    field :reason, String, null: true
    field :bypass_steps, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :context, GraphQL::Types::JSON, null: true
    field :identity_hash, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :named_task, [Types::NamedTaskType], null: true
    field :status, String, null: true
    field :complete, Boolean, null: true
    field :requested_at, GraphQL::Types::ISO8601DateTime, null: true
    field :initiator, String, null: true
    field :source_system, String, null: true
    field :reason, String, null: true
    field :bypass_steps, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :context, GraphQL::Types::JSON, null: true
    field :identity_hash, String, null: true
  end
end
