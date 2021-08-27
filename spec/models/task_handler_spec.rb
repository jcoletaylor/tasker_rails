# frozen_string_literal: true

require 'rails_helper'
require_relative '../mocks/dummy_task'

RSpec.describe 'TaskHandlers', type: :model do
  describe 'DummyTask' do
    before(:all) do
      @factory = TaskHandlers::HandlerFactory.instance
    end
    it 'should be able to initialize a dummy task and get the handler' do
      task_handler = DummyTask.new
      expect(task_handler.step_templates.first.handler_class).to eq('DummyTask::Handler')
    end
    it 'handler factory should be able to find the correct handler' do
      task_handler = @factory.get(DummyTask::TASK_REGISTRY_NAME)
      expect(task_handler.step_templates.first.handler_class).to eq('DummyTask::Handler')
    end
    it 'should be able to initialize a task' do
      task_handler = @factory.get(DummyTask::TASK_REGISTRY_NAME)
      task = task_handler.initialize_task!(task_name: DummyTask::TASK_REGISTRY_NAME, context: { dummy: :value })
      expect(task).to be_valid
      expect(task.save).to be_truthy
      task.reload
      expect(task.workflow_steps.count).to eq(4)
    end
    it 'should be able to initialize and handle a task' do
      task_handler = @factory.get(DummyTask::TASK_REGISTRY_NAME)
      task = task_handler.initialize_task!(task_name: DummyTask::TASK_REGISTRY_NAME, context: { dummy: :value })
      task_handler.handle(task)
      task.reload
      step_states = task.workflow_steps.map(&:status)
      expect(step_states).to eq(%w[complete complete complete complete])
    end
  end
end