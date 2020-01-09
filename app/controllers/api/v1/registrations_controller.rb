module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :authenticate_user, only: [:create]
      def create
        build_resource(sign_up_params)

        if resource.save
          if resource.persisted?
            if resource.active_for_authentication?
              sign_up(resource_name, resource)
            else
              expire_data_after_sign_in!
            end
            render_success_response({
              users: single_serializer.new(resource, serializer: Users::UserAttributesSerializer)
            }, I18n.t('devise.registrations.signed_up'))
          else
            render_unprocessable_entity_response(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          render_unprocessable_entity_response(resource)
        end
      end

     private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
