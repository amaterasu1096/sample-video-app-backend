module Api
  module V1
    class VideosController < BaseController
      before_action :authenticate_user!, only: [:share]

      def index
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        per_page = 5
        offset = (page - 1) * per_page
        
        videos = Video.includes(:user, :votes).order(id: :desc).limit(per_page).offset(offset)
        total_count = Video.count

        render json: {
          videos: ActiveModelSerializers::SerializableResource.new(videos, each_serializer: VideoSerializer, current_user: current_user),
          meta: {
            current_page: page,
            total_pages: (total_count / per_page.to_f).ceil,
            total_count: total_count
          }
        }
      end

      def share
        video_url = params[:video_url]
        return render json: { error: 'Video URL is required!' }, status: :unprocessable_entity unless video_url

        begin
          video_info = VideoInfo.new(video_url)
        rescue VideoInfo::UrlError => e
          return render json: { error: e.message }, status: :unprocessable_entity
        end

        video = current_user.videos.build(url: video_url, title: video_info.title, description: video_info.description)

        if video.save
          VideoNotificationJob.perform_later(video.title, current_user.email)
          render json: { message: 'Video shared successfully' }, status: :ok
        else
          render json: { error: video.errors.full_messages.join('. ') }, status: :unprocessable_entity
        end
      end
    end
  end
end
