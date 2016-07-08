require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "Login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, {
      session: {
        email: "",
        password: ""
      }
    }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login followed by logout" do
    get login_path
    assert_template "sessions/new"
    post login_path, {
      session: {
        email: @user.email,
        password: "password"
      }
    }
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", login_path, count: 0
    assert is_logged_in?

    delete logout_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_not is_logged_in?
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", login_path, count: 1
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token

    follow_redirect!
    assert_nil assigns(:user).remember_token
    assert_not_nil assigns(:user).remember_digest
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
