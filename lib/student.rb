class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_accessor :name, :grade
  attr_reader :id

  @@all = []

  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.all
    @@all
  end

  def self.create_table
    # I don't understand how this heredoc works
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    # is the heredoc not necessary here because the command is only 1 line?
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade) # how do name: and grade: become name and grade, and don't conflict with @name and @grade?
    student.save # why can't we make .save return the saved object so we don't have to do the next line?
    student
  end
  
end
