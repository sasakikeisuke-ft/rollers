class ColumnsController < ApplicationController

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

  private
  def column_params
    params.require(:column).permit(:name, :name_ja, :data_type_id, :must_exsit, :unique).merge(model_id: params[:model_id])
  end

end
