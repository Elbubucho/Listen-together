class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  validates :content, presence: true
  validates :user_id, presence: true
  validates :track_id, presence: true
end
