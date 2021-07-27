class AppActionsController < ApplicationController
  before_action :find_app_action, only: [:edit, :update, :destroy]
  before_action :instance_variable_for_form, only: [:new, :edit]

  def new
    @app_action = AppAction.new
  end

  def create
    binding.pry
    @app_action = AppAction.new(app_action_params)
    if @app_action.save
      redirect_to new_application_app_controller_app_action_path
    else
      instance_variable_for_form
      render :new
    end
  end

  def edit
  end

  def update
    if @app_action.update
      redirect_to root_path
    else
      instance_variable_for_form
      render :edit
    end
  end

  def destroy
    @app_action.destroy
    redirect_to root_path
  end

  private

  def app_action_params
    params.require(:app_action).permit(:target, :input1, :input2, :input3, :action_type_id, :code_type_id).merge(app_controller_id: params[:app_controller_id])
  end

  def find_app_action
    @app_action = AppAction.find(params[:id])
  end

  def instance_variable_for_form
    @app_controller = AppController.find(params[:app_controller_id])
    @application = @app_controller.application
    @models = @application.models
  end

end
