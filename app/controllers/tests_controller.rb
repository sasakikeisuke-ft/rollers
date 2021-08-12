class TestsController < ApplicationController
  def index
    @gemfile = Gemfile.find_by(application_id: params[:application_id])
    @model = Model.includes(columns: :options).find(params[:model_id])
    @columns = Column.where(application_id: params[:application_id])
  end
end
