require 'json'

$db = './models/db.json'

$posts = JSON.parse(File.read($db))

def index()
  return $posts
end