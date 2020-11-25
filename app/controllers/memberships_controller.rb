class MembershipsController < ApplicationController
  def create
    @community = Community.find(params[:community_id])
    @membership = Membership.new
    @membership.user = current_user
    @membership.community = @community
    if @membership.save
      redirect_to community_path(@community)
    else
      render 'communities/show'
    end
  end
end
