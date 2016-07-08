require 'test_helper'

class UserPrivilegeCheckTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "cannot edit other people's profile" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert_redirected_to root_url
  end

  test "cannot update other people's profile" do
    log_in_as(@user)
    patch user_path(@other_user), {
    }
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect destroy to login when not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@other_user)
    end
    assert_redirected_to login_path
  end


  test "should redirect destroy to root when not admin" do
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@other_user)
    end
    assert_redirected_to root_path
  end


  test "should delete user" do
    log_in_as(@user)
    assert_difference "User.count", -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
  end
end
