module Api
  module V1
    class TweetSerializer < ActiveModel::Serializer
      attributes :id, :body, :user
    end
  end
end
