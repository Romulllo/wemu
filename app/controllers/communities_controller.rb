class CommunitiesController < ApplicationController
  def index
    if params[:query].present?
      @communities = Community.where(title: params[:query])
    else
      @communities = Community.all
    end
  end
end
