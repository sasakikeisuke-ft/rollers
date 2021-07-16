class ColumnsController < ApplicationController
  before_action :show_index, only: [:new, :edit]
  before_action :find_column, only: [:edit, :update, :destroy]

  def new
    @column = Column.new
  end

  def create
    @column = Column.new(column_params)
    @model = Model.find(params[:model_id])
    if @column.save && [1, 3, 5].include?(@model.model_type_id)
      redirect_to new_application_model_column_option_path(column_id: @column)
    elsif @column.save
      redirect_to new_application_model_column_path
    else
      show_index
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
      show_index
      render :edit
    end
  end

  def destroy
    find_column
    @column.destroy
    redirect_to new_application_model_column_path
  end

  private
  def show_index
    @application = Application.find(params[:application_id])
    @models = Model.includes(columns: :options).where(application_id: @application)
    @model = @models.find(params[:model_id])
    redirect_to new_user_session_path if @application.user_id != current_user.id
  end

  def column_params
    params.require(:column).permit(:name, :name_ja, :data_type_id, :must_exist, :unique).merge(application_id: params[:application_id], model_id: params[:model_id])
  end

  def find_column
    @column = Column.find(params[:id])
  end

end
