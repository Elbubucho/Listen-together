class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  before_create :confirm_participant

  after_create_commit do
    notify_receiver_user
    update_parent_room
    broadcast_append_to room

  end

  def confirm_participant
    return unless room.is_private
    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end

  def update_parent_room
    room.update(last_message_at: Time.now)
  end

  def notify_receiver_user
    room.participants.where.not(user_id: user_id).each do |participant|
    MessageNotification.with(message: self.body).deliver(participant.user)
  end
  end
end
