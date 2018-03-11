class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in 
  def index
    @tasks = []
    if (logged_in?)
     @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(3)
    end
  end
  

  def show
  end

  def new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:success] = 'task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'task が投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
     @task.user_id = current_user.id

    if @task.update(task_params)
      flash[:success] = 'task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'task は更新されませんでした'
      render :edit
    end
  end

  def destroy
     @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'task は正常に削除されました'
    redirect_to tasks_url
  end
    private

  # Strong Parameter
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
    
    if @task == nil
        redirect_to root_url
    end
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end
