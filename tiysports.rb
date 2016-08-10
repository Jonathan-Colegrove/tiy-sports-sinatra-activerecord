require 'sqlite3'
require 'active_record'
require 'sinatra'

require 'sinatra/reloader' if development?

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "tiysports.db"
)

# Implies there is a table named "players" (plural)
class Player < ActiveRecord::Base
  # automagically creates accessors for all of the columns
end

class Team < ActiveRecord::Base
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  @players = Player.all
  @teams = Team.all

  erb :homepage
end

get '/players/new' do
  erb :player_form
end

get '/players/update' do
  erb :player_update
end

post '/players/create' do
  # name = params["name"]
  # age = params["age"]
  # shirt_size = params["shirt_size"]
  # birthday = params["birthday"]
  #
  # person = Player.create(name: name, age: age, shirt_size: shirt_size, birthday: birthday)

  # Params is already what I'm expecting (a hash with keys
  # as the names of my colums and the values being what was
  # entered on the form)
  person = Player.create(params)

  redirect "/players/#{person.id}"
end

post '/players/search' do
  @name = params["name"]

  player = Player.where("name like '%#{@name}%'").first
  if player
    redirect "/players/#{player.id}"
  else
    erb :not_found
  end
end

post '/players/delete/:id' do
  @id = params["id"]
  player = Player.find_by(id: @id)

  if player
    player.delete
    redirect "/"
  else
    erb :not_found
  end
end

get '/players/:id' do
  player_id = params[:id]
  @player = Player.find_by(id: player_id)

  erb :player_details
end

get '/teams/new' do
  erb :team_form
end

get '/teams/update' do
  erb :team_update
end

post '/teams/create' do
  team = Team.create(params)
  redirect "/teams/#{team.id}"
end

post '/teams/search' do
  @name = params["name"]

  team = Team.where("name like '%#{@name}%'").first
  if team
    redirect "/teams/#{team.id}"
  else
    erb :team_not_found
  end
end

post '/teams/team_update' do
  @name = params["name"]

  team = Team.where("name like '%#{@name}%'").first
  if team
    redirect "/teams/#{team.id}"
  else
    erb :team_not_found
  end
end

post '/teams/delete/:id' do
  @id = params["id"]
  team = Team.find_by(id: @id)

  if team
    team.delete
    redirect "/"
  else
    erb :team_not_found
  end
end

get '/teams/:id' do
  team_id = params[:id]
  @team = Team.find_by(id: team_id)

  erb :team_details
end
