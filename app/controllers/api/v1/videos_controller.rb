module Api
  module V1
    class VideosController < BaseController
      before_action :authenticate_user!, only: [:share]

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
          render json: { message: 'Video shared successfully' }, status: :ok
        else
          render json: { error: video.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
