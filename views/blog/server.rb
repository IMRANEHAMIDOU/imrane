get "/blog" do
  posts = index()
  puts posts.inspect
  erb :"blog/blog", locals:{posts: posts}
end

get "/blog/add" do
  erb :"blog/form_post", locals:{post: {}, erreur:"", add:true}
end
  
post "/blog/add" do
  id = $posts.empty? ? 1 : $posts.last['id'] + 1
  post = {"id"=>id, "title"=> params[:title], "content"=> params[:content]}
  erreur = ""
  if (post["title"]=="" or post["content"]=="")
    erreur = "Veuillez sair le titre et le contenu !"
    erb :"blog/form_post", locals:{post: post, erreur: erreur,  add:true}
  else
    $posts << post
    refresh_db($posts, $comments)
    redirect '/blog'
  end
end
  
get '/blog/post/:id/edit' do
  post_id = params[:id].to_i
  post = $posts.find { |post| post["id"] == post_id }
  if post
    erb :"blog/form_post", locals: { post: post, erreur:'', add:false}
  else
    "Post non trouvé !" 
  end
end

post '/blog/post/:id/edit' do
  post_id = params[:id].to_i
  post = $posts.find { |post| post["id"] == post_id }
  if post
    post["title"] = params[:title]
    post["content"] = params[:content]
    refresh_db($posts, $comments)
    redirect "/blog"
  end
end
  
get '/blog/post/:id' do
  post_id = params[:id].to_i
  post = $posts.find { |post| post["id"] == post_id }
  comments = $comments.find_all{|comment| comment['post_id']==post_id}

  if post
    erb :"blog/show", locals: { post: post, comments: comments}
  else
    puts "Post non trouvé !" 
  end
end
  
get '/blog/post/:id/delet' do
  post_id = params[:id].to_i
  $posts.reject! { |post| post["id"] == post_id }
  refresh_db($posts, $comments)
  redirect "/blog"
end
  
  #---------------------------------- Section commentaire ---------------------------------------
post '/blog/post/:post' do

  id_comment =  params[:id] 
  post_id = params[:post].to_i
  comment_content = params[:comment]

  if id_comment.empty?
      new_comment = {
        'id' => $comments.empty? ? 1 : $comments.last['id'] + 1,
        'content' => comment_content,
        'post_id'=> post_id
      }
  
      $comments << new_comment

      refresh_db($posts, $comments)

      redirect "/blog/post/#{post_id}"

  else
    
    puts $comments.inspect
    comment =  $comments.find{|comment| comment["id"] == id_comment.to_i }
    puts comment.inspect

    comment['content'] = comment_content

    refresh_db($posts, $comments)
    
    redirect "/blog/post/#{post_id}"

  end
end
  
get '/blog/post/:post_id/comment/:comment/delet' do
  post_id = params[:post_id].to_i
  id_comment = params[:comment].to_i
  $comments.reject! { |comment| comment['id'] == id_comment }

  refresh_db($posts, $comments)

  redirect "/blog/post/#{post_id}"
end