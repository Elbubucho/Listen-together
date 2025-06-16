class User < ApplicationRecord

  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false}, class_name: 'Invitation', foreign_key: "receiver_id"

  has_many :friendships_as_asker, class_name: "Friendship", foreign_key: :asker_id, dependent: :destroy
  has_many :friendships_as_receiver, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy
  has_many :messages
  has_one_attached :avatar

  scope :all_except, -> (user) { where.not(id: user)}
  after_create_commit { broadcast_append_to "users"}

  validates :username, presence: true, uniqueness: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def friends
  User.where(id: friendships_as_asker.where(confirmed: true).select(:receiver_id))
      .or(User.where(id: friendships_as_receiver.where(confirmed: true).select(:asker_id)))
  end

  def pending_friend_requests_sent
    friendships_as_asker.where(confirmed: false).includes(:receiver).map(&:receiver)
  end

  def pending_friend_requests_received
    friendships_as_receiver.where(confirmed: false).includes(:asker).map(&:asker)
  end
end
