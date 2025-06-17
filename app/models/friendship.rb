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

  after_create_commit :notify_asker
  after_update_commit :notify_receiver

  private

  def notify_asker
    FriendshipNotification.with(
      message: "#{asker.username} sent you a friend request.",
      asker_id: self.asker.id,
      receiver_id: self.receiver.id
    ).deliver_later(receiver)
  end

  def notify_receiver
    FriendshipNotification.with(
      message: "#{receiver.username} accepted your friend request.",
      receiver_id: self.receiver.id,
      asker_id: self.asker.id
    ).deliver_later(asker)
  end
end
