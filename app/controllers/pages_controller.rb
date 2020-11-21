class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]

  def home
  end

  def landing
  end

  def profile
    # if params[:query].present?
    #   @profiles = Profile.where(name: params[:query])
    # else
    #   @profiles = Profile.all
    # end
  end
end
