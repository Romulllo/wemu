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

    # require "json"
    # require "rest-client"

    # response = RestClient.get("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")
    # repos = JSON.parse(response)

    # repos['drinks'].each do |repo|
    #   ingredient = repo['strIngredient1']
    #   Ingredient.create!(name: ingredient)
    # end

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
