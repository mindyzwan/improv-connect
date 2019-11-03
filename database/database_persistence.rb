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
end