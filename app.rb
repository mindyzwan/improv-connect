require 'sinatra'
require 'sinatra/reloader'
require "sinatra/content_for"

require_relative 'database/database_persistence'

configure do

end

before do
  @storage = DatabasePersistence.new
end

get "/" do
  erb :home
end

get "/users" do
  @all_users = @storage.all_users
  erb :users
end

get "/users/new" do
  erb :new_user
end
