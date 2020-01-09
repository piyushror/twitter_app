class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ApplicationMethods
  protect_from_forgery with: :null_session
end
