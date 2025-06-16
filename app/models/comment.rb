class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true

  after_create_commit :notify_post_user

  private

  def notify_post_user
    return if post.user == user

    CommentNotification.with(
      message: "#{user.username} commented your post.",
      comment_id: self.id
    ).deliver_later(post.user)
  end
end
