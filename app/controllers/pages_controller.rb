class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]

  def results
    if params[:query].present?
      @community = Community.where(name: params[:query])
    else
      @community = Community.all
    end
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
