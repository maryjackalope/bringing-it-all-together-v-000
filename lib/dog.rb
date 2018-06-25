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
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, breed:)
    dog = Dog.new(name, grade)
    dog.save
    dog
  end

 end	 
