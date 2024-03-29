# typed: strict
# frozen_string_literal: true

module Types
  class AnnotationType < Types::BaseObject
    field :annotation_type_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :description, String, null: true
    field :name, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
