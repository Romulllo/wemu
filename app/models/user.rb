class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [ :spotify ]

  has_many :memberships
  has_many :messages
  has_many :communities
  has_many :communities, through: :memberships
  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  def self.find_for_oauth(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name")
    user_params[:first_name] = auth.extra.raw_info.display_name
    user_params[:nickname] = auth.info.nickname
    user_params[:spotify_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    time = Time.now.getutc

    response = RestClient.get('https://api.spotify.com/v1/me/player/recently-played?limit=9', { Authorization: "Bearer #{user_params[:token]}", accept: :json })
    spotify_response = JSON.parse(response)
    spotify_last_artists = []
    spotify_last_songs   = []
    spotify_last_albums  = []
    spotify_link_albums  = []
    spotify_last_songs_id = []

    # response_1 = RestClient.get('https://api.spotify.com/v1/me', { Authorization: "Bearer #{user_params[:token]}", accept: :json })
    # spotify_response_1 = JSON.parse(response_1)
    # spotify_countries = []
    # spotify_followers = []

    response_2 = RestClient.get('https://api.spotify.com/v1/me/top/artists?limit=10', { Authorization: "Bearer #{user_params[:token]}", accept: :json })
    spotify_response_top_artists = JSON.parse(response_2)
    spotify_top_artists = []
    spotify_link_artists = []
    spotify_link_album_top_artists = []

    response_3 = RestClient.get('https://api.spotify.com/v1/me/top/tracks?limit=10&time_range=long_term', { Authorization: "Bearer #{user_params[:token]}", accept: :json })
    spotify_response_top_songs = JSON.parse(response_3)
    spotify_top_songs = []
    spotify_link_songs = []
    
    spotify_response['items'].each do |item|
      spotify_last_artists << item['track']['album']['artists'][0]['name']
      spotify_last_songs << item['track']['name']
      spotify_last_songs_id << item['track']['id']
      spotify_last_albums << item ['track']['album']['images'][1]['url']
      spotify_link_albums << item['track']['album']['external_urls']['spotify']
    end

    spotify_response_top_songs['items'].each do |item|
      spotify_top_songs << item['name']
      spotify_link_songs << item['external_urls']["spotify"]
    end

     spotify_response_top_artists['items'].each do |item|
      spotify_top_artists << item['name']
      spotify_link_artists << item['external_urls']['spotify']
      spotify_link_album_top_artists << item['images'][0]['url']
    end

    # spotify_response_1['country'].each do |x|
    #   spotify_countries << x
    # end

    # spotify_response_1['followers'].each do |follower|
    #   spotify_followers << follower
    # end

    user_params[:last_artists] = spotify_last_artists
    user_params[:last_songs] = spotify_last_songs
    user_params[:last_albums] = spotify_last_albums
    user_params[:link_albums] = spotify_link_albums
    user_params[:top_artists] = spotify_top_artists
    user_params[:top_songs] = spotify_top_songs
    user_params[:link_artists] = spotify_link_artists
    user_params[:link_songs] = spotify_link_songs
    user_params[:last_songs_identifiers] = spotify_last_songs_id
    user_params[:link_album_top_artists] = spotify_link_album_top_artists

    # user_params[:country] = spotify_countries
    # user_params[:followers] = spotify_followers
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.

    if user
      user.update(user_params)
      user.save!
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end
    return user
  end

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  def is_following?(user_id)
    relationship = Follow.find_by(follower_id: id, following_id: user_id)
    return true if relationship
  end

  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :first_name ],
    using: {
      tsearch: { prefix: true }
    }
end
