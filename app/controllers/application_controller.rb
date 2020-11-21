class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  def after_sign_in_path_for(user)
    home_path(user)
  end

  def after_sign_out_path_for(user)
    landing_path(user)
  end
end
