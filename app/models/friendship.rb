class Friendship < ApplicationRecord
  belongs_to :asker, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :asker_id, uniqueness: { scope: :receiver_id }
  validate :asker_and_receiver_cannot_be_the_same

  def asker_and_receiver_cannot_be_the_same
    if asker_id == receiver_id
      errors.add(:receiver_id, "can't be the same as asker")
    end
  end
end
