class CommunitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :create_playlist, :search_track, :add_track_playlist]

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
    @track_items = search_track(params[:query]) if params[:query]
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
    @community.destroy
    redirect_to home_path
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

  def search_track(search_field)
    response = RestClient.get("https://api.spotify.com/v1/search?q=#{search_field}&type=track&market=US&limit=3", { Authorization: "Bearer #{current_user.token}", accept: :json })
    response_search = JSON.parse(response)

    track_items = []

    track_items << response_search['tracks']['items']
  end

  def add_track_playlist    
    RestClient.post("https://api.spotify.com/v1/playlists/#{@community.playlist}/tracks?position=0&uris=#{params[:item]}", { Authorization: "Bearer #{current_user.token}", accept: :json })

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
