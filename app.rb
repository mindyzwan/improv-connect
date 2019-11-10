require 'sinatra'
require "sinatra/content_for"
require "pry"

require_relative 'database/database_persistence'

configure do

end

configure(:dvelopment) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
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

post "/users/new" do
  first_name = params[:first_name].strip
  last_name = params[:last_name].strip
  email = params[:email].strip

  @storage.add_new_user(first_name, last_name, email)

  redirect "/users"
end

post "/users/:id/delete" do
  id = params[:id].to_i
  @storage.delete_user(id)

  redirect "/users"
end

get "/users/:id/edit" do 
  id = params[:id].to_i
  @user = @storage.get_user_from_id(id)

  erb :edit_user
end

post "/users/:id/edit" do
  id = params[:id].to_i
  @user = @storage.get_user_from_id(id)

  first_name = params[:first_name].strip
  last_name = params[:last_name].strip
  email = params[:email].strip

  @storage.edit_user_from_id(id, first_name, last_name, email)

  redirect "/users"
end

get "/teams" do
  @all_teams = @storage.all_teams

  erb :teams
end

get "/teams/new" do
  erb :new_team
end

post "/teams/new" do
  name = params[:name].strip
  description = params[:description].strip

  @storage.add_new_team(name, description)

  redirect "/users"
end
