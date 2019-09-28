ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "minitest/reporters"
require "rack/test"
MiniTest::Reporters.use!

require_relative "../app.rb"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup

  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
  end

  def test_users
    get "/users"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"] 
    assert_includes last_response.body, "<dt>Mindy Zwanziger</dt>"
    assert_includes last_response.body, "<a href=\"/users/new\">"
  end

  def test_new_user
    get "/users/new"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"] 
    assert_includes last_response.body, "<form action=\"/users/new\" method=\"post\">"
  end

end