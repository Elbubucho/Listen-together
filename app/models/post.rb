class Post < ApplicationRecord
  belongs_to :user

  ORDER_BY = { newest: "created_at DESC", oldest: "created_at ASC", popular: "COUNT(reactions.id) DESC"}.freeze

  MOODS = ["😊 Happy", "😢 Sad", "🤩 Excited", "😎 Chill", "😡 Angry", "🥲 Nostalgic" ]

  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  validates :track_id, presence: true
  validates :mood, presence: true, inclusion: { in: MOODS }
end
