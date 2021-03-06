class ModelsController < ApplicationController
  before_action :find_model, only: [:edit, :update, :destroy]

  def index
    @models = Model.where(application_id: params[:application_id]).includes(:columns)
  end

  def new
    show_index
    @model = Model.new
  end

  def create
    @model = Model.new(model_params)
    if @model.save
      redirect_to new_application_model_column_path(model_id: @model)
    else
      show_index
      render :new
    end
  end

  def edit
    @application = Application.find(params[:application_id])
  end

  def update
    before_name = @model.name
    if @model.update(model_params)
      after_name = @model.name
      ProcessAtModelNameChangeService.rename_all(before_name, after_name, params[:application_id])
      redirect_to new_application_model_column_path(model_id: @model)
    else
      render :edit
    end
  end

  def destroy
    @model.destroy
    redirect_to application_models_path(params[:application_id])
  end

  def show
    @gemfile = Gemfile.find_by(application_id: params[:application_id])
    @model = Model.includes(columns: :options).find(params[:id])
  end

  private

  def model_params
    params.require(:model).permit(:name, :model_type_id, :not_only,
                                  :attached_image).merge(application_id: params[:application_id])
  end

  def find_model
    @model = Model.find(params[:id])
    redirect_to root_path if current_user.id != @model.application.user_id
  end

  def show_index
    @application = Application.find(params[:application_id])
    @models = Model.where(application_id: params[:application_id])
  end
end
