module Api
  module V1
    class UsersSerializer < ActiveModel::Serializer
      attributes :id, :email
    end
  end
end
