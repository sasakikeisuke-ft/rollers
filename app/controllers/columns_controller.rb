class ColumnsController < ApplicationController
  before_action :related_models
  before_action :find_column, only: [:edit, :update, :destroy]

  def new
    @model = Model.find(params[:model_id])
    @column = Column.new
  end

  def create
    @column = Column.new(column_params)
    if @column.save
      redirect_to new_application_model_column_option_path(params[:application_id], params[:model_id], @column)
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
      @column.options.each do |option|
        option.destroy
      end
      redirect_to new_application_model_column_option_path(column_id: @column)
    else
      @model = Model.find(params[:model_id])
      render :edit
    end
  end

  def destroy
    find_column
    @column.destroy
    redirect_to new_application_model_column_path
  end

  private
  def related_models
    @application = Application.find(params[:application_id])
    @models = Model.where(application_id: @application).includes(columns: :options)
    redirect_to new_user_session_path if @application.user_id != current_user.id
  end

  def column_params
    params.require(:column).permit(:name, :name_ja, :data_type_id, :must_exsit, :unique).merge(model_id: params[:model_id])
  end

  def find_column
    @column = Column.find(params[:id])
    redirect_to root_path if current_user.id != @column.model.application.user_id
  end

end
