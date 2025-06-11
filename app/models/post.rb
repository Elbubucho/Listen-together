class Post < ApplicationRecord
  belongs_to :user

  MOODS = ["😊", "😢", "🤩", "😎", "😡"]

  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  validates :content, presence: true
  validates :user_id, presence: true
  validates :track_id, presence: true
  validates :mood, presence: true, inclusion: { in: MOODS }
end
