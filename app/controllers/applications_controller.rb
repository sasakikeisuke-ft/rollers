class ApplicationsController < ApplicationController
  before_action :find_application, only: [:edit, :update, :destroy]

  def index
    @applications = Application.where(user_id: current_user.id )
  end

  def show
    @application = Application.find(params[:id])
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to new_application_gemfile_path(@application.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @application.update(application_params)
      redirect_to edit_application_gemfile_path(@application.id)
    else
      render :edit
    end
  end

  def destroy
    @application.destroy
    redirect_to root_path
  end

  private
  def application_params
    params.require(:application).permit(:name, :description).merge(user_id: current_user.id)
  end

  def find_application
    @application = Application.find(params[:id])
    redirect_to root_path if current_user.id != @application.user_id
  end

end
