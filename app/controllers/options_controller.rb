class OptionsController < ApplicationController
  before_action :find_option, only: [:edit, :update, :destroy]

  def new
    column_index
    @option = Option.new
  end

  def create
    @option = Option.new(option_params)
    if @option.save
      redirect_to new_application_model_column_option_path
    else
      column_index
      render :new
    end
  end

  private

  def option_params
    unless params[:option].nil?
      params.require(:option).permit(:option_type_id, :input1,
                                     :input2).merge(column_id: params[:column_id])
    end
  end

  def column_index
    @column = Column.find(params[:column_id])
    @options = @column.options
  end
end
