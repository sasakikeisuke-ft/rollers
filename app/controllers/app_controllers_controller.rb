class AppControllersController < ApplicationController
  before_action :app_controller_form_variable, only: [:new, :edit]
  before_action :find_app_controller, only: [:edit, :update, :destroy, :show]

  def index
    @application = Application.find(params[:application_id])
    @app_controllers = @application.app_controllers
  end

  def new
    app_controller_form_variable
    @app_controller = AppController.new
  end

  def create
    @app_controller = AppController.new(app_controller_params)
    if @app_controller.save
      SetDefaultActionService.set(@app_controller)
      redirect_to application_app_controller_app_actions_path(app_controller_id: @app_controller)
    else
      app_controller_form_variable
      render :new
    end
  end

  def edit
  end

  def update
    if @app_controller.update(app_controller_params)
      redirect_to application_app_controllers_path
    else
      app_controller_form_variable
      render :edit
    end
  end

  def destroy
    @app_controller.destroy
    redirect_to application_app_controllers_path
  end

  def show
    @gemfile = Gemfile.find_by(application_id: params[:application_id])
    @app_controllers = AppController.where(application_id: params[:application_id])
    @app_actions = AppAction.where(app_controller_id: params[:id])
  end

  private

  def app_controller_form_variable
    @application = Application.find(params[:application_id])
    @models = @application.models
    @app_controllers = @application.app_controllers
  end

  def app_controller_params
    params.require(:app_controller).permit(:name, :parent, :index_select, :new_select, :create_select, :edit_select, :update_select,
                                           :destroy_select, :show_select).merge(application_id: params[:application_id])
  end

  def find_app_controller
    @app_controller = AppController.find(params[:id])
  end
end
