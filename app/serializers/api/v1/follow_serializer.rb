module Api
  module V1
    class FollowSerializer < ActiveModel::Serializer
      attributes :id, :user, :f_user
    end
  end
end
