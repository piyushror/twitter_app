module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :authenticate_user, only: [:create]

      def create
        user = User.find_by_email(params[:user][:email])
        if user && user.valid_password?(params[:user][:password])
          @current_user = user

          respond_to do |format|
            if @bids
              format.json { render 'bids/index',  collection: @bids }
            else
              format.json { render json: "Bid not found" }
            end
          end
          render_success_response({
            user: Users::UserAttributesSerializer.new(@current_user)
          })
        else
          render_unprocessable_entity(I18n.t('devise.errors.invalid_credentials'))
        end
      end
    end
  end
end
