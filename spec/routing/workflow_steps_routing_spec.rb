# typed: false
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkflowStepsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/tasks/1/workflow_steps').to route_to('workflow_steps#index', task_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/tasks/1/workflow_steps/1').to route_to('workflow_steps#show', task_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/tasks/1/workflow_steps').to route_to('workflow_steps#create', task_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/tasks/1/workflow_steps/1').to route_to('workflow_steps#update', task_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/tasks/1/workflow_steps/1').to route_to('workflow_steps#update', task_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/tasks/1/workflow_steps/1').to route_to('workflow_steps#destroy', task_id: '1', id: '1')
    end
  end
end
