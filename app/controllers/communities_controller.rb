class CommunitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :create_playlist]

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user

    @membership = Membership.new
    @membership.user = current_user
    @membership.community = @community

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

  def create_playlist    
    playlist = RestClient.post("https://api.spotify.com/v1/users/#{current_user.uid}/playlists", {
      "name": "#{@community.name}",
      "description": "#{@community.description}",
      "public": true
    }.to_json, { Authorization: "Bearer #{current_user.token}", accept: :json })
    
    response = JSON.parse(playlist)
    playlist_spotify = ''
    playlist_spotify << response['id']

    @community.playlist = playlist_spotify
    @community.save

    redirect_to community_path(@community)

    
  end

  private

  def set_community
    id = params[:id] ? params[:id] : params[:community_id]
    @community = Community.find(id)
  end

  def community_params
    params.require(:community).permit(:name, :description, :photo, :playlist)
  end
end
