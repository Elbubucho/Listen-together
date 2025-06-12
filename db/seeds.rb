User.destroy_all

user1 = User.create!(
  email: "alice@example.com",
  password: "password123",
  username: "alice"
)

user2 = User.create!(
  email: "bob@example.com",
  password: "password123",
  username: "bob"
)
  puts "Created users"


Post.create!(
  content: "Feeling good today 😎",
  mood: "😎 Chill",
  track_id: "4uLU6hMCjMI75M1A2tKUQC",
  user: user1
)

Post.create!(
  content: "Late night vibes...",
  mood: "🥲 Nostalgic",
  track_id: "0VjIjW4GlUZAMYd2vXMi3b",
  user: user1
)

Post.create!(
  content: "Let’s go party!",
  mood: "🤩 Excited",
  track_id: "1301WleyT98MSxVHPZCA6M",
  user: user2
)

Post.create!(
  content: "Relaxing with some jazz 🎷",
  mood: "😊 Happy",
  track_id: "5CtI0qwDJkDQGwXD1H1cLb",
  user: user2
)
