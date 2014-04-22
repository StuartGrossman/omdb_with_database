require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

# A setup step to get rspec tests running.
configure do
  root = File.expand_path(File.dirname(__FILE__))
  set :views, File.join(root,'views')
end

get '/' do

erb :index
end

get '/movies' do
  # binding.pry
 c = PGconn.new(:host => "localhost", :dbname => dbname) #creates new connection to database
 @movies = c.exec_params("select * from movies WHERE title = $1;", [params["title"]]) #exec_params allows you access variables           
  c.close
  binding.pry 
end


#Add code here
#query the database for the movie_name that matches it

get '/movies/new' do #this seraches the database for the movie/title 
  erb :new
end

post '/movies' do
  c = PGconn.new(:host => "localhost", :dbname => dbname) #creates new connection to database
  c.exec_params("INSERT INTO movies (title, year) VALUES ($1, $2)", #exec_params allows you access variables
                  [params["title"], params["year"]])
  c.close
  redirect '/'
end

def dbname
  "testdb"
end

def create_movies_table
  connection = PGconn.new(:host => "localhost", :dbname => dbname)
  connection.exec %q{
    ,
    plot text,
    genre varchar(255)
  );
  }
  connection.close
end

def drop_movies_table
  connection = PGconn.new(:host => "localhost", :dbname => dbname)
  connection.exec "DROP TABLE movies;"
  connection.close
end

def seed_movies_table
  movies = [["Glitter", "2001"],
              ["Titanic", "1997"],
              ["Sharknado", "2013"],
              ["Jaws", "1975"]
             ]
 
  c = PGconn.new(:host => "localhost", :dbname => dbname)
  movies.each do |p|
    c.exec_params("INSERT INTO movies (title, year) VALUES ($1, $2);", p)
  end
  c.close
end

