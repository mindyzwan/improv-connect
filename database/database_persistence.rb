require "pg"

class DatabasePersistence
  def initialize
    @db = PG.connect(dbname: "improv_connect")
  end

  def query(statement, *params)
    @db.exec_params(statement, params)
  end

  def all_users
    sql = "SELECT * FROM users"
    result = query(sql)
    
    result.map do |tuple|
      {id: tuple["id"], first_name: tuple["first_name"], last_name: tuple["last_name"], email: tuple["email"]}
    end
  end

  def add_new_user(first_name, last_name, email)
    sql = "INSERT INTO users (first_name, last_name, email) VALUES ($1, $2, $3)"
    query(sql, first_name, last_name, email)
  end
end