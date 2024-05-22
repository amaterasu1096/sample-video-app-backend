require "test_helper"

class VideoTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: "user@example.com", password_digest: "password")
    @video = Video.new(user: @user, title: "Example Video", url: "https://www.youtube.com/watch?v=abcdef")
  end

  test "should be valid" do
    assert @video.valid?
  end

  test "user_id should be present" do
    @video.user_id = nil
    assert_not @video.valid?
  end

  test "title should be present" do
    @video.title = " "
    assert_not @video.valid?
  end

  test "url should be present" do
    @video.url = " "
    assert_not @video.valid?
  end
end
