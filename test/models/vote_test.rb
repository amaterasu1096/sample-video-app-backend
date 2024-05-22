require "test_helper"

class VoteTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: "user@example.com", password_digest: "password")
    @video = Video.create(user: @user, title: "Example Video", url: "https://www.youtube.com/watch?v=abcdef")
    @vote = Vote.new(user: @user, video: @video, vote_type: 1)
  end

  test "should be valid" do
    assert @vote.valid?
  end

  test "user_id should be present" do
    @vote.user_id = nil
    assert_not @vote.valid?
  end

  test "video_id should be present" do
    @vote.video_id = nil
    assert_not @vote.valid?
  end

  test "vote_type should be present" do
    @vote.vote_type = nil
    assert_not @vote.valid?
  end
end
