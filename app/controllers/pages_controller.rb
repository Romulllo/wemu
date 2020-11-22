class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]

  def result
    if params[:query].present?
      @communities = Community.where(name: params[:query])
    else
      @communities = Community.all
    end
  end

  def landing
  end

  def profile
  end
end
