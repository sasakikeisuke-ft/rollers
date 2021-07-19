class AppControllersController < ApplicationController

  def index
    @application = Application.find(params[:application_id])
    @app_controllers = @application.app_controllers
  end

end
