# frozen_string_literal: true

class TaskRunnerJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 3

  def perform(*args)
    # Do something later
  end
end
