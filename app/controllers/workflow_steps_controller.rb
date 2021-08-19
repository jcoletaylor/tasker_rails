# frozen_string_literal: true

class WorkflowStepsController < ApplicationController
  before_action :set_workflow_step, only: %i[show update destroy]

  # GET /workflow_steps
  def index
    @workflow_steps = WorkflowStep.all

    render json: @workflow_steps
  end

  # GET /workflow_steps/1
  def show
    render json: @workflow_step
  end

  # POST /workflow_steps
  def create
    @workflow_step = WorkflowStep.new(workflow_step_params)

    if @workflow_step.save
      render json: @workflow_step, status: :created, location: @workflow_step
    else
      render json: @workflow_step.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workflow_steps/1
  def update
    if @workflow_step.update(workflow_step_params)
      render json: @workflow_step
    else
      render json: @workflow_step.errors, status: :unprocessable_entity
    end
  end

  # DELETE /workflow_steps/1
  def destroy
    @workflow_step.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workflow_step
    @workflow_step = WorkflowStep.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def workflow_step_params
    params.require(:workflow_step).permit(:task_id, :named_step_id, :depends_on_step_id, :status, :retryable,
                                          :retry_limit, :in_process, :processed, :processed_at, :attempts, :last_attempted_at, :backoff_request_seconds, :inputs, :results)
  end
end
