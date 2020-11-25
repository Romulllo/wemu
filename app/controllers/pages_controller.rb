class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]

  def result
    if params[:query].present?
    # @communities = Community.where("name ILIKE ?", params[:query])
      @communities = Community.search_by_name(params[:query])
    else
      @communities = Community.all
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
