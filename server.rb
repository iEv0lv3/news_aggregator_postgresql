require 'sinatra'
require 'pry'
require 'pg'

#Update 1. I was calling back the incorrect param to display article title

#PSQL Connection

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

#Get and Post request processing

#Get request to display articles
get '/articles' do
  articles = db_connection { |conn| conn.exec("SELECT story, description, url FROM articles")}
  all_articles = articles.to_a
  erb :style1, locals: { all_articles: all_articles }
end

#Get request to submit new article page
get "/articles/new" do
  erb :style2
end

#Post request to add user input to database
post "/articles/new" do
  # Read the input from the form the user filled out
  article_title = params['article_title']
  article_description = params['article_description']
  article_url = params['article_url']
  post_article = db_connection { |conn| conn.exec_params("INSERT INTO articles (story, description, url) VALUES ($1,$2,$3)", [article_title, article_description, article_url])}
  #Send back to hompage after submit
  redirect '/articles'
end
