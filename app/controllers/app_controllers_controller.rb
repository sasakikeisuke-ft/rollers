class AppControllersController < ApplicationController
  before_action :get_common_matter, only: [:new, :edit]
  before_action :find_app_controller, only: [:edit, :update, :destroy, :show]

  def index
    @application = Application.find(params[:application_id])
    @app_controllers = @application.app_controllers
  end

  def new
    get_common_matter
    @app_controller = AppController.new
  end

  def create
    @app_controller = AppController.new(app_controller_params)
    if @app_controller.save
      redirect_to application_app_controllers_path
    else
      get_common_matter
      render :new
    end
  end

  def edit
  end

  def update
    if @app_controller.update(app_controller_params)
      redirect_to application_app_controllers_path
    else
      get_common_matter
      render :edit
    end
  end

  def destroy
    @app_controller.destroy
    redirect_to application_app_controllers_path
  end

  def show
  end

  private

  def get_common_matter
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
