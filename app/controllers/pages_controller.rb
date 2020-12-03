class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]
  before_action :set_user, only: [:follow, :unfollow]

  def result
    if params[:query].present?
      Community.reindex
      User.reindex
    # @communities = Community.where("name ILIKE ?", params[:query])
      # @communities = Community.search_by_name(params[:query])
      @communities = Community.search(params[:query])
      @profiles = User.search(params[:query])
    else
      @communities = Community.all
      @profiles = User.all
    end

  end

  def landing
  end

  def profile
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

