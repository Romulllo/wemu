class CommunitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :create_playlist, :search_track]

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

  def search_track(search)
    @search = search
    response = RestClient.get("api.spotify.com/v1/search?q=#{@search}&type=track&market=US&limit=1", { Authorization: 'Bearer BQBz5wAMfdn_g2HpZ_VW7yIHHSXFen1_P0APoO79XfW9Q35WUI-KH6R7HdaIISXPe38SUFCv5xa2G5TGoJ1gLTAZy8mCXyQmLibeA9ifaWLH_xKnpjJpzF45XhBmX41hee3cHUBVfwxIjnw3-ur1nBE5Y5Tzqw4G88I0uRBrW4AuFgfY7-LjeDtsZ2CZHscg-sOCTjb4pDEWhlcwaTVfcwAHOszamrZ_TIMt', accept: :json })
    response_search = JSON.parse(response)

    @search_track_id = response_search['tracks']['items'][0]['uri']
    @search_track_name = response_search['tracks']['items'][0]['name']
    @search_track_artists = response_search['tracks']['items'][0]['artists'][0]['name']

    redirect_to community_path(@community)
  end

  def add_track_playlist
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
