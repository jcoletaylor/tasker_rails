# typed: strict
# frozen_string_literal: true

module Types
  class TaskAnnotationType < Types::BaseObject
    field :annotation, GraphQL::Types::JSON, null: true
    field :annotation_type_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :task_annotation_id, ID, null: false
    field :annotation_type, Types::AnnotationType, null: true
    field :task_id, Integer, null: false
    field :task, Types::TaskType, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
