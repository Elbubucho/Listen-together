class CommentNotification < Noticed::Base

  deliver_by :database
  deliver_by :action_cable, format: :to_action_cable

  # On attend un paramètre :message (chaîne de caractères)
  param :message, :post_id

  # Après la livraison, nous diffusons la notification via Turbo Streams
  after_deliver :broadcast_notification

  def to_database
    { message: params[:message], post_id: params[:post_id]}
  end

  def to_action_cable
    { title: "New comment", message: params[:message], post_id: params[:post_id], id: record.id }
  end

  private

  def broadcast_notification
    recipient.broadcast_prepend_later_to(
      "notifications_#{recipient.id}_list",
      target: "notification-list",
      partial: "notifications/notification",
      locals: { notification: self.record }
    )

    recipient.broadcast_prepend_later_to(
      "notifications_#{recipient.id}_indicator",
      target: "notification-indicator",
      partial: "notifications/notification_indicator",
      locals: { user: recipient }
    )
  end
end
