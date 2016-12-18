ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # 残念ながらlogged_in?ヘルパーメソッドはテストでは呼び出せないので、
  # それと同様のログイン状態をチェックするメソッドを用意する。sessionメソッドはテストでも利用できる
  def is_logged_in?
    !session[:user_id].nil?
  end
end
