class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit :notify_post_user

  private

  def notify_post_user
    return if post.user == user

    ReactionNotification.with(
      message: "#{user.username} liked your post."
    ).deliver_later(post.user)
  end
end
