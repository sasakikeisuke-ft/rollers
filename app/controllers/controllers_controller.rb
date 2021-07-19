class ControllersController < ApplicationController
  def index
    @application = Application.find(params[:application_id])
    @controllers = @application.controllers
  end

end
