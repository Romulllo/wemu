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

  def self.find_for_oauth(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name")
    user_params[:first_name] = auth.extra.raw_info.display_name
    user_params[:nickname] = auth.info.nickname
    user_params[:spotify_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    time = Time.now.getutc

    response = RestClient.get('https://api.spotify.com/v1/me/player/recently-played?limit=10', { Authorization: "Bearer #{user_params[:token]}", accept: :json })
    spotify_response    = JSON.parse(response)
    spotify_top_artists = []
    spotify_top_songs   = []

    spotify_response['items'].each do |item|
      spotify_top_artists << item['track']['album']['artists'][0]['name']
      spotify_top_songs << item['track']['name']
    end

    user_params[:top_artists] = spotify_top_artists
    user_params[:top_songs] = spotify_top_songs
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
end
