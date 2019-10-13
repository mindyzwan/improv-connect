ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "minitest/reporters"
require "rack/test"
require "pry"
MiniTest::Reporters.use!

require_relative "../app.rb"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @test_storage = DatabasePersistence.new
    @test_storage.add_new_user('Test', 'User', 'test@user.com')
  end

  def teardown
    tables = ['users', 'teams', 'teams_users']
    tables.each do |table_name|
      sql = "DELETE FROM #{table_name}"
      @test_storage.query(sql)
    end
  end

  def create_test_user
    test_user_email = 'robert@fakemail.com'
    @test_storage.add_new_user('Robert', 'Frost', test_user_email)
    @test_user = @test_storage.get_user_from_email(test_user_email)
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
    assert_includes last_response.body, "<dt>Test User</dt>"
  end

  def test_new_user
    get "/users/new"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"] 
    assert_includes last_response.body, "<form action=\"/users/new\" method=\"post\">"
  end

  def test_post_new_user
    post "/users/new", first_name: "Julia", last_name: "Childs", email: "julia@fakemail.com"

    assert_equal 302, last_response.status

    get "/users"
    assert_includes last_response.body, 'Julia Childs'
  end

  def test_delete_user
    create_test_user

    post "/users/#{@test_user[:id]}/delete"

    assert_equal 302, last_response.status

    get "/users"
    refute_includes last_response.body, 'Robert Frost'
  end

  def test_edit_user_route
    create_test_user

    get "/users/#{@test_user[:id]}/edit"
    assert_equal 200, last_response.status
  end

end