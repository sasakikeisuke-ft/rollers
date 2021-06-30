class ColumnsController < ApplicationController
  before_action :related_models, only: [:new, :edit]
  before_action :find_column, only: [:edit, :update, :destroy]

  def new
    @column = Column.new
  end

  def create
    @column = Column.new(column_params)
    if @column.save
      redirect_to new_application_model_column_option_path(params[:application_id], params[:model_id], @column)
    else
      related_models
      render :new
    end
  end

  def edit
  end

  def update
    if @column.update(column_params)
      @column.options.each do |option|
        option.destroy
      end
      redirect_to new_application_model_column_option_path(column_id: @column)
    else
      related_models
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
    @model = @models.find(params[:model_id])
    redirect_to new_user_session_path if @application.user_id != current_user.id
  end

  def column_params
    params.require(:column).permit(:name, :name_ja, :data_type_id, :must_exsit, :unique).merge(application_id: params[:application_id], model_id: params[:model_id])
  end

  def find_column
    @column = Column.find(params[:id])
  end

end
