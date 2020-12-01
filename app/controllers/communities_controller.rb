class CommunitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_community, only: [:show, :edit, :update, :destroy]

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user

    @membership = Membership.new
    @membership.user = current_user
    @membership.community = @community

    playlists = RestClient.post("https://api.spotify.com/v1/users/#{current_user.uid}/playlists", {
      "name": "#{@community.name}",
      "description": "#{@community.description}",
      "public": true
    }, { Authorization: "Bearer #{current_user.token}", accept: :json })

    playlists

    if @community.save && @membership.save
      redirect_to community_path(@community)
    else
      render 'new'
    end
  end

  # def index
  #   @communities = Community.all
  # end

  def show
    @message = Message.new
    @membership = Membership.new
    @current_membership = Membership.where(user: current_user, community: @community)
  end

  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to community_path(@community)
    else
      render 'edit'
    end
  end

  def destroy
    @community.delete
    redirect_to communities
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :description, :photo)
  end
end
