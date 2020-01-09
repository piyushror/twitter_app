module Api
  module V1
    class TweetsController < Api::V1::ApiController
      before_action :find_user, only: :user_tweets

      def feeds
        @tweets = Tweet.where(user: current_user.followings).order( "tweets.created_at #{params[:order] || 'ASC'}" )

        render_success_response({
          tweets: array_serializer.new(@tweets, serializer: TweetSerializer)
        })
      end

      def create
        @tweet = current_user.tweets.build(tweet_params)
        if @tweet.save
          render_success_response({
              tweet: single_serializer.new(@tweet, serializer: TweetSerializer)
            }, I18n.t('created', resource: 'Tweet'), status = 200)
        else
          render_unprocessable_entity_response(@tweet)
        end
      end

      def user_tweets
        render_success_response({
          tweets: array_serializer.new(@user.tweets, serializer: TweetSerializer)
        })
      end

      private

      def find_user
        @user = User.find(params[:user_id])
      end

      def tweet_params
        params.require(:tweet).permit(:body)
      end
    end
  end
end
