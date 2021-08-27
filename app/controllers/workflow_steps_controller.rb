# frozen_string_literal: true

class WorkflowStepsController < ApplicationController
  include PageSort

  before_action :set_task, only: %i[index show update destroy]
  before_action :set_workflow_step, only: %i[show update destroy]
  before_action :set_page_sort_params, only: [:index]

  # GET /workflow_steps
  def index
    @workflow_steps =
      query_base.limit(page_sort_params[:limit])
                .offset(page_sort_params[:offset])
                .order(page_sort_params[:order])
                .all

    render json: @workflow_steps, status: :ok, adapter: :json
  end

  # GET /workflow_steps/1
  def show
    render json: @workflow_step, status: :ok, adapter: :json
  end

  # PATCH/PUT /workflow_steps/1
  def update
    if @workflow_step.update(workflow_step_params)
      render json: @workflow_step, status: :ok, adapter: :json
    else
      render json: { error: @workflow_step.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /workflow_steps/1
  def destroy
    @workflow_step.update({ status: Constants::WorkflowStepStatuses::CANCELLED })
    render status: :ok, json: { cancelled: true }
  end

  private

  def query_base
    @task.workflow_steps.includes(:named_step)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_workflow_step
    @workflow_step = query_base.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def workflow_step_params
    params.require(:workflow_step).permit(:retry_limit, :inputs)
  end

  def set_page_sort_params
    build_page_sort_params(:workflow_step, :workflow_step_id)
  end
end
