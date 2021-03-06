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
    create_test_team
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

  def create_test_team
    description = 'A rockin group of A to L level improvisors'
    @test_storage.add_new_team('M-Prov', description)
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
    assert_includes last_response.body, "Edit User"
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
    assert_includes last_response.body, "Editing #{@test_user[:first_name]}"
    assert_includes last_response.body, "<form action=\"/users/#{@test_user[:id]}/edit\" method=\"post\">"
  end

  def test_edit_user
    create_test_user

    post "/users/#{@test_user[:id]}/edit", first_name: 'Jennifer', last_name: 'Anniston', email: 'janni@fakeemail.com'
    assert_equal 302, last_response.status

    get "/users"
    assert_includes last_response.body, 'Jennifer Anniston'
  end

  def test_teams
    get "/teams"

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'M-Prov'
  end

  def test_new_team
    get "/teams/new"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "<form action=\"/teams/new\" method=\"post\">"
  end

  def test_post_new_team
    post "/teams/new", name: "Con People", description: "A conglomeration of beautiful people"

    assert_equal 302, last_response.status

    get "/teams"
    assert_includes last_response.body, 'Con People'
  end

end