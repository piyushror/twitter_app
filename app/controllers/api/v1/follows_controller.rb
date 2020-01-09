module Api
  module V1
    class FollowsController < Api::V1::ApiController
      before_action :find_follow, only: :unfollow

      def follow
        @follow = Follow.new(f_user_id: params[:user_id], user_id: current_user.id)
        if @follow.save
          render_success_response({
              follow: single_serializer.new(@follow, serializer: FollowSerializer)
            }, I18n.t('created', resource: 'Follow'), status = 200)
        else
          render_unprocessable_entity_response(@follow)
        end
      end

      def unfollow
        if @follow.destroy
          render_success_response({}, "Unfollowed successfully", status = 200)
        else
          render_unprocessable_entity_response(@follow)
        end
      end

      private

      def find_follow
        @follow = Follow.find_by(f_user_id: params[:user_id], user_id: current_user.id)
        render_unprocessable_entity('Follow Not Found') unless @follow
      end
    end
  end
end
