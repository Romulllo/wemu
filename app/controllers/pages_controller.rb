class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing ]

  def result
    if params[:query].present?
      @communities = Community.where(name: params[:query])
    else
      @communities = Community.all
    end
  end

  def landing
  end

  def profile
    # RSpotify.authenticate("4300c468d3404ad1a1c20c00fdba64c6", "3497fb6aa30c4cf994c6fdae0075561a")

    # if params[:query].present?
    #   @profiles = Community.where(name: params[:query])
    # else
    #   @profiles = Community.all
    # end

    # @artists = RSpotify::Artist.search('Arctic Monkeys')

    require 'net/http'
    require 'json'
    require 'uri'

    response = RestClient.get('https://api.spotify.com/v1/me/player/recently-played?limit=10',
      { Authorization: 'Bearer BQDSTQfvjrjDOIcrAWdIo2Z-eceaW5SJ6JYVFhmc5SsZrkGc7HD87CDOD9yO1WbUHlSTfMQcqmdkFh8Ntiva6qXQOjoATh3URJ_10sabdmFQ_2Z02tL4W7YPas0m2VcZdZhHRs9uELjt-IS90owjhzTJsvWDE8QweQ03lx50ms3dWyyi1SmjsukRWCh70KDYfMW2F7Q7HmWTFv7QjlAlSQ43P5DsvR_jVSyN7hwaeFy2oWGURRMc1U30mUygD35pvlfQi3nRBu8oscxi9Fo', 
        accept: :json 
      })

    @repos = JSON.parse(response)
  end
end
