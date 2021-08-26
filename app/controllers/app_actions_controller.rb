class AppActionsController < ApplicationController
  before_action :find_app_action, only: [:edit, :update, :destroy]
  before_action :app_action_form_variable, only: [:new, :edit]

  def index
    @app_controller = AppController.find(params[:app_controller_id])
    @app_controllers = AppController.where(application_id: params[:application_id])
    @app_actions = @app_controller.app_actions
  end

  def new
    @app_action = AppAction.new
  end

  def create
    @app_action = AppAction.new(app_action_params)
    if @app_action.save
      redirect_to application_app_controller_app_actions_path
    else
      app_action_form_variable
      render :new
    end
  end

  def edit
  end

  def update
    if @app_action.update(app_action_params)
      redirect_to application_app_controller_app_actions_path
    else
      app_action_form_variable
      render :edit
    end
  end

  def destroy
    @app_action.destroy
    redirect_to application_app_controller_app_actions_path
  end

  private

  def app_action_params
    params.require(:app_action).permit(:target, :input1, :input2, :input3, :action_select, :action_code_id).merge(
      application_id: params[:application_id], app_controller_id: params[:app_controller_id]
    )
  end

  def find_app_action
    @app_action = AppAction.find(params[:id])
  end

  def app_action_form_variable
    @app_controller = AppController.includes(:app_actions).find(params[:app_controller_id])
    @application = @app_controller.application
    @models = @application.models.where(model_type_id: [1, 3, 5])
  end
end
