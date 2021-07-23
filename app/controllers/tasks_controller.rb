class TasksController < ApplicationController
  before_action :set_task, only:  [:show, :edit, :update, :destroy]
  def index
    @tasks = current_user.tasks.order(created_at: :desc).page(params[:page])

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d')}.csv"}
    end
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: "completed to add tasks"
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save!
      redirect_to tasks_url, notice: "Completed to register task [#{@task.name}]."
    else
      render :new
    end
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url ,notice: "Completed to update task [#{@task.name}]."
  end

  def destroy
    @task.destroy
    redirect_to tasks_url ,notice: "Completed to delete task [#{@task.name}]."
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
