class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]
  before_action :set_user, only: [:follow, :unfollow]

  def result
    if params[:query].present?

    # @communities = Community.where("name ILIKE ?", params[:query])
      @communities = Community.search_by_name(params[:query])
      @profiles = User.search_by_name(params[:query])
    else
      @communities = Community.all
    end

    @communities_auto = Community.pluck(:name).sort
  end

  def landing
  end

  def profile
  end

  def home
    @communities_auto = Community.pluck(:name).sort
    @users_auto = User.pluck(:first_name).sort
  end

  def follow
    if current_user.follow(@user.id)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def unfollow
    if current_user.unfollow(@user.id)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render action: :follow }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end


end

