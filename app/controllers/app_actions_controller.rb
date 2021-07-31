class AppActionsController < ApplicationController
  before_action :find_app_action, only: [:edit, :update, :destroy]
  before_action :instance_variable_for_form, only: [:new, :edit]

  def index
    @app_controller = AppController.find(params[:app_controller_id])
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
      instance_variable_for_form
      render :new
    end
  end

  def edit
  end

  def update
    if @app_action.update(app_action_params)
      redirect_to application_app_controller_app_actions_path
    else
      instance_variable_for_form
      render :edit
    end
  end

  def destroy
    @app_action.destroy
    redirect_to application_app_controller_app_actions_path
  end

  private

  def app_action_params
    params.require(:app_action).permit(:target, :input1, :input2, :input3, :action_select, :code_type_id).merge(app_controller_id: params[:app_controller_id])
  end

  def find_app_action
    @app_action = AppAction.find(params[:id])
  end

  def instance_variable_for_form
    @app_controller = AppController.find(params[:app_controller_id])
    @application = @app_controller.application
    @models = @application.models.where(model_type_id: [1, 3, 5])
  end

end
