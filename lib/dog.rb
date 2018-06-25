class Dog
  
  attr_accessor :name, :breed
  attr_reader :id
  @@all= []
  
  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end 
  
  def self.create_table
    sql = <<-SQL
  CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(params)
    dog = Dog.new(params)
    dog.save
    dog
  end
  
  def self.new_from_db(row)
   id = row[0]
   name = row[1]
   breed = row[2]
   dog= self.new(id, name, breed)
   dog
 end
 
  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Dog.new(result[0], result[1], result[2])
  end
  
  def self.find_by_id(id)
  sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?;
    SQL

    result = DB[:conn].execute(sql, id)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
  end
 
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

 end	 
