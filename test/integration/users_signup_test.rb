require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup info" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, {
        user: {
          name: "",
          email: "invalid"
        }
      }
    end

    user = assigns :user
    assert user.errors[:name].include? ("can't be blank")

    assert_template 'users/new'
    assert_select "div#error_explanation"
  end

  test "valid signup" do
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, {
        user: {
          name: "sakop",
          email: "aa@a.com",
          password: "123456",
          password_confirmation: "123456"
        }
      }

      assert_redirected_to root_path
      assert_equal "Please check your email to activate your account.", flash[:info]
      assert_equal 1, ActionMailer::Base.deliveries.size

      user = assigns(:user)
      assert_not user.activated?

      log_in_as(user, password: user.password)
      assert_not is_logged_in?
      assert_redirected_to root_path
      follow_redirect!
      assert_select "div.alert-warning", text: "Account not activated. Check your email for the activation link."

      get edit_account_activation_path("invalid token", email: user.email)
      assert_not is_logged_in?
      assert_redirected_to root_path
      follow_redirect!
      assert_select "div.alert-danger", text: "Invalid activation link"

      get edit_account_activation_path(user.activation_token, email: user.email)
      assert is_logged_in?
      assert_redirected_to user_path(user)
      follow_redirect!
      assert_template 'users/show'
    end
  end

end
