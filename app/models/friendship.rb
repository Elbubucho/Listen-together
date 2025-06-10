class Friendship < ApplicationRecord
  belongs_to :asker, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :asker, presence: true
  validates :receiver, presence: true
end
