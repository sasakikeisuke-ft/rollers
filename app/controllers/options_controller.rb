class OptionsController < ApplicationController
  before_action :find_option, only: [:edit, :update, :destroy]

  def new
    @column = Column.find(params[:column_id])
    @options = @column.options
    @option = Option.new
  end

  def create
    @option = Option.new(option_params)
    if @option.save
      redirect_to new_application_model_column_option_path(params[:application_id], params[:model_id], params[:column_id])
    else
      redirect_to new_application_model_column_path(params[:application_id], params[:model_id]) if params[:option] == nil
    end
  end

  private
  def option_params
    params.require(:option).permit(:option_type_id, :input1, :input2).merge(column_id: params[:column_id]) if params[:option] != nil
  end

end
