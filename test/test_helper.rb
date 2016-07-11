ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"

support_dir = Rails.root.join('test/support/**/*')
Dir.glob(support_dir).each do |file|
  require file
end

Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  def is_logged_in?
    !session[:user_id].nil?
  end

  class ActionDispatch::IntegrationTest
    # Log in as a particular user.
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, {session: {email: user.email,
                                  password: password,
                                  remember_me: remember_me}}
    end
  end
  # Add more helper methods to be used by all tests here...
end
