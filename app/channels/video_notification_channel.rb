class VideoNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'new_video'
  end
end
