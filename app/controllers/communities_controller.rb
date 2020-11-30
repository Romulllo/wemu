class CommunitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_community, only: [:show, :edit, :update, :destroy]

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user

    playlists = RestClient.post("https://api.spotify.com/v1/users/#{current_user.uid}/playlists", {
      "name": "#{@community.name}",
      "description": "#{@community.description}",
      "public": false
    }, { Authorization: "Bearer BQB4hKNP9e4Dizrfs3Fu1Eg8gNaG0JosGYDVraocw-Z1w5Bf-RXMaJwR3W5JQFd1y7DOP9ajsRl0NOyIYCPXmtfHoRsWW2uv0UT6VRUVS6zZ74_HEtiBd1ftxh9ykaS6HiCvY6OSn6LwwlTHYKMsQLf2YU9y5M3ctrLnzyZLSSzEjHD_2V_TL1guibKZ9ecJaviqecTzLQUM1VHpdDiQdxVWrcAYral7kXrC", accept: :json })

    playlists

    if @community.save
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
