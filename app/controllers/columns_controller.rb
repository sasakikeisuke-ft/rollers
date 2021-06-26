class ColumnsController < ApplicationController
  before_action :find_column, only: [:edit, :update, :destroy]

  def new
    @model = Model.find(params[:model_id])
    @column = Column.new
  end

  def create
    @column = Column.new(column_params)
    if @column.save
      redirect_to new_application_model_column_path(params[:application_id], params[:model_id])
    else
      @model = Model.find(params[:model_id])
      render :new
    end
  end

  def edit
    @model = Model.find(params[:model_id])
  end

  def update
    if @column.update(column_params)
      redirect_to application_models_path(params[:application_id])
    else
      @model = Model.find(params[:model_id])
      render :edit
    end
  end

  private
  def column_params
    params.require(:column).permit(:name, :name_ja, :data_type_id, :must_exsit, :unique).merge(model_id: params[:model_id])
  end

  def find_column
    @column = Column.find(params[:id])
    redirect_to root_path if current_user.id != @column.model.application.user_id
  end

end
