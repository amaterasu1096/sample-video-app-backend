require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "user@example.com", password_digest: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "password_digest should be present" do
    @user.password_digest = " "
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
end
