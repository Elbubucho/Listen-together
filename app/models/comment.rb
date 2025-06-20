class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true

  after_create_commit :broadcast_comment
  after_create_commit :notify_post_user

  private

  def broadcast_comment
    broadcast_prepend_to(
      "notifications__list",
      target: "comment",
      partial: "comments/comment",
      locals: { comment: self }
    )
  end

  def notify_post_user
    return if post.user == user

    CommentNotification.with(
      message: "#{user.username} commented your post.",
      post_id: self.post.id
    ).deliver_later(post.user)
  end
end
