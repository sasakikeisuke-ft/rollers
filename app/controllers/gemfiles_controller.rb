class GemfilesController < ApplicationController
  before_action :find_gemfile, only: [:edit, :update]

  def new
    @gemfile = Gemfile.new
  end

  def create
    @gemfile = Gemfile.new(gemfile_params)
    if @gemfile.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @gemfile.update(gemfile_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def gemfile_params
    params.require(:gemfile).permit(:devise, :pry_rails,:image_magick, :active_hash, :rails_i18n, :ransack, :rubocop, :rspec, :payjp, :s3).merge(application_id: params[:application_id])
  end

  def find_gemfile
    @application = Application.find(params[:application_id])
    @gemfile = @application.gemfile
    redirect_to root_path if current_user.id != @application.user_id
    redirect_to new_application_gemfile_path(@application.id) if @gemfile == nil
  end

end