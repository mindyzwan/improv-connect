require "pg"

class DatabasePersistence
  def initialize
    @db = PG.connect(dbname: "improv_connect")
  end

  def all_users
    sql = "SELECT * FROM users"
    result = @db.exec(sql)
    
    result.map do |tuple|
      {id: tuple["id"], first_name: tuple["first_name"], last_name: tuple["last_name"], email: tuple["email"]}
    end
  end
end