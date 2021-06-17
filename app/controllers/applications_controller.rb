class ApplicationsController < ApplicationController

  def index
    @applications = Application.where(user_id: current_user.id )
  end

  def new
    @application = Application.new
  end

def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def application_params
    params.require(:application).permit(:name, :description).merge(user_id: current_user.id)
  end
end
