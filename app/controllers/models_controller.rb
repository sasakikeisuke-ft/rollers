class ModelsController < ApplicationController
  before_action :find_model, only: [:edit, :update, :destroy]

  def index
    @models = Model.where(application_id: params[:application_id]).includes(:columns)
  end

  def new
    @gemfile = Gemfile.find_by(application_id: params[:application_id])
    @models = Model.where(application_id: params[:application_id])
    @model = Model.new
  end

  def create
    @model = Model.new(model_params)
    if @model.save
      redirect_to new_application_model_column_path(params[:application_id], @model)
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
    params.require(:model).permit(:name, :model_type_id, :not_only).merge(application_id: params[:application_id])
  end

  def find_model
    @model = Model.find(params[:id])
    redirect_to root_path if current_user.id != @model.application.user_id
  end

end
