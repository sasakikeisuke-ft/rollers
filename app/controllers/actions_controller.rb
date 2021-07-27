class ActionsController < ApplicationController
  before_action :find_action, only: [:edit, :update, :destroy]
  before_action :instance_variable_for_form, only: [:new, :edit]

  def new
    @action = Action.new
  end

  def create
    @action = Action.new(action_params)
    if @action.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @action.update
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @action.destroy
    redirect_to root_path
  end

  private

  def action_params
    params.require(:action).permit(:target, :input1, :input2, :input3, :action_type_id, :aciton_code_id).merge(app_controller_id: params[:app_controller])
  end

  def find_action
    @action = Action.find(params[:id])
  end

  def instance_variable_for_form
    @app_controller = AppController.find(params[:app_controller_id])
    @application = @app_controller.application
    @models = @application.models
  end

end
