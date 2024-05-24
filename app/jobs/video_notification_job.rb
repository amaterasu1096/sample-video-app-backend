class VideoNotificationJob < ApplicationJob
  self.queue_adapter = :async
  queue_as :video_notification

  def perform(video_title, video_user_email)
    ActionCable.server.broadcast('new_video', { title: video_title, email: video_user_email } )
  end
end
