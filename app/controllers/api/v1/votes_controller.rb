module Api
  module V1
    class VotesController < BaseController
      before_action :authenticate_user!

      def create
        video = Video.find(params[:video_id])
        vote_type = params[:vote_type]

        unless %w[upvote downvote].include?(vote_type)
          return render json: { error: 'Invalid vote type' }, status: :unprocessable_entity
        end

        user_vote = video.votes.find_by(user_id: @current_user.id)

        if user_vote.nil?
          video.votes.create(user_id: @current_user.id, vote_type: vote_type)
          render json: { message: 'Vote created successfully', vote_type: vote_type }, status: :ok
        elsif user_vote.vote_type == vote_type
          user_vote.destroy
          render json: { message: "#{vote_type.capitalize} removed successfully", vote_type: nil }, status: :ok
        else
          user_vote.update(vote_type: vote_type)
          render json: { message: 'Vote updated successfully', vote_type: vote_type }, status: :ok
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Video not found' }, status: :not_found
      end
    end
  end
end
