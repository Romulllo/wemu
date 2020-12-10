class UsersController < ApplicationController
  before_action :set_user, only: [:follow, :unfollow, :show]

  # def index
  #   @users = User.where.not(id: current_user.id)
  # end

  def show
    if current_user == @user
      redirect_to profile_path
    end
  end


  def follow
    if current_user.follow(@user.id)
      redirect_to user_path(@user)
    end
  end

  def unfollow
    if current_user.unfollow(@user.id)
      redirect_to user_path(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
