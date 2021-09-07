# typed: false
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
      expect(task_handler.step_templates.first.handler_class).to eq(DummyTask::Handler)
    end
    it 'handler factory should be able to find the correct handler' do
      task_handler = @factory.get(DummyTask::TASK_REGISTRY_NAME)
      expect(task_handler.step_templates.first.handler_class).to eq(DummyTask::Handler)
    end
    it 'should be able to initialize a task' do
      task_handler = @factory.get(DummyTask::TASK_REGISTRY_NAME)
      task_request = TaskRequest.new(name: DummyTask::TASK_REGISTRY_NAME, context: { dummy: :value })
      task = task_handler.initialize_task!(task_request)
      expect(task).to be_valid
      expect(task.save).to be_truthy
      task.reload
      expect(task.workflow_steps.count).to eq(4)
    end
    it 'should be able to initialize and handle a task' do
      task_handler = @factory.get(DummyTask::TASK_REGISTRY_NAME)
      task_request = TaskRequest.new(name: DummyTask::TASK_REGISTRY_NAME, context: { dummy: :value })
      task = task_handler.initialize_task!(task_request)
      task_handler.handle(task)
      task.reload
      step_states = task.workflow_steps.map(&:status)
      expect(step_states).to eq(%w[complete complete complete complete])
      expect(task.task_annotations.count).to eq(4)
      # check on steps to ensure that the dependencies mapped correctly

      step_two = task.workflow_steps.includes(:named_step).where(named_step: { name: DummyTask::STEP_TWO }).first
      step_three = task.workflow_steps.includes(:named_step).where(named_step: { name: DummyTask::STEP_THREE }).first
      step_four = task.workflow_steps.includes(:named_step).where(named_step: { name: DummyTask::STEP_FOUR }).first

      expect(step_two.depends_on_step_id).to be_nil
      expect(step_three.depends_on_step_id).to eq(step_two.workflow_step_id)
      expect(step_four.depends_on_step_id).to eq(step_three.workflow_step_id)
    end
  end
end
