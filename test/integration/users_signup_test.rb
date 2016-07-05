require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

      follow_redirect!
      assert_template 'users/show'
      assert_not flash.nil?
      assert_select "div.alert-success"
    end
  end

end
