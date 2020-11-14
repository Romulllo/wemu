class ProfilesController < ApplicationController
  def index
    if params[:query].present?
      @profiles = Community.where(name: params[:query])
    else
      @profiles = Community.all
    end
  end
end
