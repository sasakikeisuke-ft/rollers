class AssociationsController < ApplicationController

  def new
  #   @models = Model.where(application_id: params[:application_id])
   redirect_to new_application_model_column_path(params[:application_id], params[:model_id])
  end
end
