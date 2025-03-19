require 'json'

$file = './models/db.json'

$db = JSON.parse(File.read($file))
$posts = $db['posts']
$comments =  $db['comments']

def index()
  return $posts
end

def refresh_db(posts,comments)
  data = {posts: posts, comments: comments}
  File.write($file, JSON.pretty_generate(data))
end