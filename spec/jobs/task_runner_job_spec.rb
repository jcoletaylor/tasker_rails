# typed: false
# frozen_string_literal: true

require 'rails_helper'
require_relative '../mocks/dummy_task'
require_relative '../helpers/task_helpers'

RSpec.describe TaskRunnerJob, type: :job do
  context 'perform a task runner job' do
    let(:helper) { Helpers::TaskHelpers.new }
    let(:task_handler) { helper.factory.get(DummyTask::TASK_REGISTRY_NAME) }
    let(:task_request) { TaskRequest.new(name: DummyTask::TASK_REGISTRY_NAME, context: { dummy: true }) }
    let(:task) { task_handler.initialize_task!(task_request) }
    before(:all) do
      DependentSystem.find_or_create_by!(name: Helpers::TaskHelpers::DEPENDENT_SYSTEM)
    end
    it 'should be able to perform a task job' do
      runner = TaskRunnerJob.new
      runner.perform(task.task_id)
      task.reload
      expect(task.status).to eq(Constants::TaskStatuses::COMPLETE)
    end
  end
end
