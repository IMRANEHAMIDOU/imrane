# myapp.rb
require 'sinatra'
require './fonctions'
require './models/post'

require 'sinatra/reloader' if development?


configure :development do
  register Sinatra::Reloader
end

get '/' do
  erb :home
end

get '/isogram' do
  erb :"tp isogram/isogram", locals: { iso: false, world: "" }
end

post '/isogram' do
  world = params[:world]
  iso = verif_isogram(world)
  erb :"tp isogram/isogram", locals: { iso: iso, world: world }
end

get '/calculator' do
  expression = params[:expression]

  result = calculatrice(expression)

  erb :"tp calculator/calculatrice", locals: {result: result, expression: expression}
end

get '/adn' do
  adn1 = params[:adn1]
  adn2 = params[:adn2]
  
  result = adn(adn1, adn2)
  erb :"tp adn/adn", locals: {result: result, adn1: adn1, adn2: adn2}
end


get "/recorder1" do
  text = params[:text]
  result = help(text)
  erb :"tp recoder 1/recorder1", locals:{result:result, text: text}
end

get "/recorder2" do
  text = params[:text]
  result = record(text)
  erb :"tp recorder 2/recorder2", locals:{result:result, text: text}
end

#les urls de blog
require './views/blog/server'

#bank systeme
require "./views/tp bank systeme/server"

get "/dashboard" do
  erb :"frontend/dashbord"
end

get '/tp1js' do
  erb :"frontend/tp1js"
end
get '/calc' do
  erb :"frontend/calculatrice"
end
get '/citation' do
  erb :"frontend/citation"
end
get '/jeu_mystere' do
  erb :"frontend/jeu_mystere"
end
