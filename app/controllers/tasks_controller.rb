# frozen_string_literal: true

class TasksController < ApplicationController
  include PageSort

  before_action :set_task, only: %i[update destroy]
  before_action :set_full_task, only: %i[show]
  before_action :set_page_sort_params, only: %i[index]

  # GET /tasks
  def index
    @tasks =
      query_base.limit(page_sort_params[:limit])
                .offset(page_sort_params[:offset])
                .order(page_sort_params[:order])
                .all
    render json: @tasks, status: :ok, adapter: :json
  end

  # GET /tasks/1
  def show
    render json: @task, status: :ok, adapter: :json
  end

  # POST /tasks
  def create
    begin
      handler = handler_factory.get(task_params[:name])
      @task = handler.initialize_task!(task_params)
    rescue TaskHandlers::ProceduralError => e
      @task = Task.new
      @task.errors.add(:name, e.to_s)
    end

    if @task.save
      render json: @task, status: :created, adapter: :json
    else
      render status: :unprocessable_entity, json: { error: @task.errors }
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(update_task_params)
      render json: @task, status: :ok, adapter: :json
    else
      render json: { error: @task.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.status = Constants::TaskStatuses::CANCELLED
    @task.save
    render status: :ok, json: { deleted: true }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def set_full_task
    @task = query_base.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:name, :initiator, :source_system, :reason, :tags, context: {})
  end

  def update_task_params
    params.require(:task).permit(:reason, :tags)
  end

  def set_page_sort_params
    build_page_sort_params(:task, :task_id)
  end

  def handler_factory
    @handler_factory ||= TaskHandlers::HandlerFactory.instance
  end

  def query_base
    Task.includes(:named_task)
        .includes(workflow_steps: %i[named_step depends_on_step])
        .includes(task_annotations: %i[annotation_type])
  end
end
