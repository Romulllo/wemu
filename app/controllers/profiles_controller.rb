class ProfilesController < ApplicationController
  def index
    if params[:query].present?
      @profiles = Profile.where(name: params[:query])
    else
      @profiles = Profile.all
    end
  end
end
