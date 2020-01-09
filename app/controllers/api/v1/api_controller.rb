class Api::V1::ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ApplicationMethods
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  def per_page
    10
  end
end
