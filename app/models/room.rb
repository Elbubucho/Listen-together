class Room < ApplicationRecord
  has_many :messages,  dependent: :destroy
  has_many :participants, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  scope :public_rooms, -> {where(is_private: false)}
  after_update_commit {broadcast_if_public }

  def broadcast_if_public
    return if is_private
    broadcast_latest_message
  end

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end
    single_room
  end

  def latest_message
    messages.includes(:user).order(created_at: :desc).first
  end

  def broadcast_latest_message
    last_message = latest_message

    return unless last_message

    user_target = "room_#{id} user_last_message"
    sender = Current.user.eql?(last_message.user) ? Current.user : last_message.user

    broadcast_update_to('rooms',
                      target: user_target,
                      partial: 'users/last_message',
                      locals: {
                        room: self,
                        user: last_message.user,
                        last_message: last_message,
                        sender: sender
                      })

  end
end
