class GemfilesController < ApplicationController
  before_action :find_gemfile, only: [:index, :edit, :update]
  before_action :gemfile_form_variable, only: [:new, :edit]

  def index
    @application = Application.find(params[:application_id])
  end

  def new
    @gemfile = Gemfile.new
  end

  def create
    @gemfile = Gemfile.new(gemfile_params)
    if @gemfile.save
      redirect_to new_application_model_path(params[:application_id])
    else
      gemfile_form_variable
      render :new
    end
  end

  def edit
  end

  def update
    if @gemfile.update(gemfile_params)
      redirect_to root_path
    else
      gemfile_form_variable
      render :edit
    end
  end

  def show
    @application = Application.includes(models: :columns).find(params[:id])
    @models = @application.models
    @columns = Column.includes(:model).where(application_id: @application)
    @gemfile = @application.gemfile
    @devise = @models.find_by(model_type_id: 5)
    @app_controllers = @application.app_controllers
  end

  private

  def gemfile_params
    params.require(:gemfile).permit(:devise, :pry_rails, :image_magick, :active_hash, :rails_i18n, :ransack, :rubocop, :rspec,
                                    :payjp, :s3).merge(application_id: params[:application_id])
  end

  def find_gemfile
    @application = Application.find(params[:application_id])
    @gemfile = @application.gemfile
    redirect_to root_path if current_user.id != @application.user_id
    redirect_to new_application_gemfile_path(@application.id) if @gemfile.nil?
  end

  def gemfile_form_variable
    @application = Application.find(params[:application_id])
  end

end
