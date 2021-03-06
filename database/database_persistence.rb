require "pg"

class DatabasePersistence
  def initialize
    if Sinatra::Base.test?
      @db = PG.connect(dbname: "improv_connect_test")
    else
      @db = PG.connect(dbname: "improv_connect")
    end
  end

  def disconnect
    @db.close
  end

  def query(statement, *params)
    @db.exec_params(statement, params)
  end

  def tuple_to_user_hash_array(query_result)
    query_result.map do |tuple|
      {id: tuple["id"], first_name: tuple["first_name"], last_name: tuple["last_name"], email: tuple["email"]}
    end
  end

  def all_users
    sql = "SELECT * FROM users"
    result = query(sql)
    
    tuple_to_user_hash_array(result)
  end

  def add_new_user(first_name, last_name, email)
    sql = "INSERT INTO users (first_name, last_name, email) VALUES ($1, $2, $3)"
    query(sql, first_name, last_name, email)
  end

  def delete_user(id)
    sql = "DELETE FROM users WHERE id=$1"
    query(sql, id)
  end

  def get_user_from_email(email)
    sql = "SELECT * FROM users WHERE email=$1"
    result = query(sql, email)
    user = tuple_to_user_hash_array(result)[0]
  end

  def get_user_from_id(id)
    sql = "SELECT * FROM users WHERE id=$1"
    result = query(sql, id)
    user = tuple_to_user_hash_array(result)[0]
  end

  def edit_user_from_id(id, new_first_name, new_last_name, new_email)
    sql = "UPDATE users SET first_name = $1, last_name = $2, email = $3 WHERE id = $4"
    query(sql, new_first_name, new_last_name, new_email, id)
  end

  def tuple_to_team_hash_array(query_result)
    query_result.map do |tuple|
      {id: tuple["id"], name: tuple["team_name"], description: tuple["description"]}
    end
  end

  def add_new_team(team_name, description)
    sql = "INSERT INTO teams (team_name, description) VALUES ($1, $2)"
    query(sql, team_name, description)
  end

  def all_teams
    sql = "SELECT * FROM teams"
    result = query(sql)

    tuple_to_team_hash_array(result)
  end

end