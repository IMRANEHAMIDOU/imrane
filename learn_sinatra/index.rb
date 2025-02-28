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
  erb :isogram, locals: { iso: false, world: "" }
end

post '/isogram' do
  world = params[:world]
  iso = verif_isogram(world)
  erb :isogram, locals: { iso: iso, world: world }
end


get '/calculator' do
  expression = params[:expression]

  result = calculatrice(expression)

  erb :calculatrice, locals: {result: result, expression: expression}
end

get '/adn' do
  adn1 = params[:adn1]
  adn2 = params[:adn2]
  
  result = adn(adn1, adn2)
  erb :adn, locals: {result: result, adn1: adn1, adn2: adn2}
end

get "/students" do
  text = params[:text]
  erb :students, locals:{result:"", text: text}
end

get "/help" do
  text = params[:text]
  result = help(text)
  erb :help, locals:{result:result, text: text}
end

get "/recorder" do
  text = params[:text]
  result = record(text)
  erb :recorder, locals:{result:result, text: text}
end

get "/blog" do
  posts = index()
  erb :blog, locals:{posts: posts}
end


get "/blog/add" do
  erb :form_post, locals:{post: {}, erreur:"", add:true}
end

post "/blog/add" do
  post = {"id"=>$posts.length+1, "title"=> params[:title], "content"=> params[:content]}
  erreur = ""
  if (post["title"]=="" or post["content"]=="")
    erreur = "Veuillez sair le titre et le contenu !"
    erb :form_post, locals:{post: post, erreur: erreur,  add:true}
  else
    $posts << post
    File.open($db, 'w') do |f|
      f.write(JSON.pretty_generate($posts))
    end
    redirect '/blog'
  end
end

#edition dun post
get '/blog/post/:id/edit' do
  post_id = params[:id].to_i
  post = $posts.find { |post| post["id"] == post_id }
  if post
    erb :form_post, locals: { post: post, erreur:'', add:false}
  else
    puts "Post non trouvé !" 
  end
end

#persistence la l'edition
post '/blog/post/:id/edit' do
  post_id = params[:id].to_i
  post = $posts.find { |post| post["id"] == post_id }
  if post
    post["title"] = params[:title]
    post["content"] = params[:content]
    File.write($db, JSON.pretty_generate($posts))
    redirect "/blog"
  end
end


get '/blog/post/:id/delet' do
  post_id = params[:id].to_i
  $posts.reject! { |post| post["id"] == post_id }

  File.write($db, JSON.pretty_generate($posts))
  redirect "/blog"
end

get "/dashbord" do
  erb :dashbord
end