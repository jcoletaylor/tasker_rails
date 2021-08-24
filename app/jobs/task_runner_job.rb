# frozen_string_literal: true

class TaskRunnerJob
  include Sidekiq::Worker
  sidekiq_options retry: 3, backtrace: true, queue: :default

  def perform(task_id)
    task = Task.where(task_id: task_id).first
    handler_factory = TaskHandlers::HandlerFactory.new
    handler = handler_factory.get(task.name)
    handler.handle(task)
  end
end
