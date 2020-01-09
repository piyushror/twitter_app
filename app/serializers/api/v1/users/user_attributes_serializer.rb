module Api
  module V1
    class Users::UserAttributesSerializer < ActiveModel::Serializer
      attributes :id, :email, :token

      def token
        object.generate_jwt
      end
    end
  end
end
