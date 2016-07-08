require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
  end

  test "an unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)

    previous_name = @user.name
    previous_email = @user.email

    patch user_path(@user), {
      user: {
        name: "",
        email: "aa@a"
      }
    }
    assert_template "users/edit"
    @user.reload
    assert_equal previous_name, @user.name
    assert_equal previous_email, @user.email
  end

  test "a successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)

    get edit_user_path(@user)

    new_name ="abcdef"
    new_email = "test@aa.com"

    patch user_path(@user), {
      user: {
        name: new_name,
        email: new_email
      }
    }
    follow_redirect!
    assert_not_nil flash[:success]
    assert_template "users/show"
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end

end
