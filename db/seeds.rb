User.destroy_all
Post.destroy_all
Comment.destroy_all

users = [
  { email: "emma@example.com", username: "Emma", password: "password123" },
  { email: "valentin@example.com", username: "Valentin", password: "password123" },
  { email: "elisa@example.com", username: "Elisa", password: "password123" },
  { email: "nicolas@example.com", username: "Nicolas", password: "password123" }
]

users.each do |user|
  User.create(user)
end

puts "Utilisateurs créés"

emma = User.find_by(username: "Emma")
elisa = User.find_by(username: "Elisa")

spotify_tracks = [
  "0d28khcov6AiegSCpG5TuT",
  "7GhIk7Il098yCjg4BQjzvb",
  "4PTG3Z6ehGkBFwjybzW9R8",
  "4u6h4CjMI75M1A2tKUQC",
  "3xOj5F1zVWxKQOcYPFM2YI"
]

post1 = Post.create!(
  content: "Post 1 sur une super musique !",
  mood: ["😊 Happy", "😢 Sad", "🤩 Excited", "😎 Cool", "😡 Angry"].sample,
  cover_url: "https://www.emp-online.fr/dw/image/v2/BBQV_PRD/on/demandware.static/-/Sites-master-emp/default/dw4270ad56/images/4/2/2/8/422893.jpg?sw=1000&sh=800&sm=fit&sfrm=png",
  track_id: spotify_tracks[0],
  user: emma
)

post2 = Post.create!(
  content: "Post 2 sur une super musique !",
  mood: ["😊 Happy", "😢 Sad", "🤩 Excited", "😎 Cool", "😡 Angry"].sample,
  cover_url: "https://www.emp-online.fr/dw/image/v2/BBQV_PRD/on/demandware.static/-/Sites-master-emp/default/dw4270ad56/images/4/2/2/8/422893.jpg?sw=1000&sh=800&sm=fit&sfrm=png",
  track_id: spotify_tracks[1],
  user: elisa
)

puts "posts créés"



Comment.create!(
  content: "Incroyable ce son !",
  user: User.all.sample,
  post: post1
)

Comment.create!(
  content: "Ce n'est pas ma préférée mais elle est cool",
  user: User.all.sample,
  post: post2
)
puts "commentaires créés"
