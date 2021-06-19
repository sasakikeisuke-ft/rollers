class ModelsController < ApplicationController
  before_action :find_model, only: [:edit, :update, :destroy]

  def index
    @application = Application.find(params[:application_id])
    @models = @application.models
  end

  def new
    @model = Model.new
  end

  def create
    @model = Model.new(model_params)
    if @model.save
      redirect_to application_models_path(params[:application_id])
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @model.update(model_params)
      redirect_to application_models_path(params[:application_id])
    else
      render :edit
    end
  end

  def destroy
    @model.destroy
    redirect_to application_models_path(params[:application_id])
  end

  private
  def model_params
    params.require(:model).permit(:name, :model_type_id).merge(application_id: params[:application_id])
  end

  def find_model
    @application = Application.find(params[:application_id])
    @model = @application.models
    redirect_to root_path if current_user.id != @application.user_id
  end

end
