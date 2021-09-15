# typed: true
# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'The query root of the Tasker schema'

    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :tasks, [Types::TaskType], null: true do
      description 'Find and sort tasks'
      argument :limit, Integer, required: false
      argument :offset, Integer, required: false
      argument :sort_by, String, required: false
      argument :sort_order, String, required: false
    end

    def tasks(limit:, offset:, sort_by:, sort_order:)
      sorts = page_sort_params(Task, limit, offset, sort_by, sort_order)
      task_query_base.limit(sorts[:limit]).offset(sorts[:offset]).order(sorts[:order])
    end

    field :tasks_by_status, [Types::TaskType], null: true do
      description 'Find and sort tasks by status'
      argument :limit, Integer, required: false
      argument :offset, Integer, required: false
      argument :sort_by, String, required: false
      argument :sort_order, String, required: false
      argument :status, String, required: true
    end

    def tasks_by_status(status:, limit:, offset:, sort_by:, sort_order:)
      sorts = page_sort_params(Task, limit, offset, sort_by, sort_order)
      task_query_base.where(status: status).limit(sorts[:limit]).offset(sorts[:offset]).order(sorts[:order])
    end

    field :task, Types::TaskType, null: true do
      description 'Find a task by ID'
      argument :task_id, ID, required: true
    end

    def task(task_id:)
      task_query_base.where(task_id: task_id).first
    end

    private

    def task_query_base
      Task.includes(:named_task)
          .includes(workflow_steps: %i[named_step depends_on_step])
          .includes(task_annotations: %i[annotation_type])
    end

    def page_sort_params(model, limit = 20, offset = 0, sort_by = :created_at, sort_order = :asc)
      valid_sorts = model.column_names.map(&:to_sym)
      sort_by = :created_at unless valid_sorts.include?(sort_by)
      sort_order = :asc unless %i[asc desc].include?(sort_order)
      order = { sort_by => sort_order }
      { limit: limit, offset: offset, order: order }
    end
  end
end
