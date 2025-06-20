# To deliver this notification:
#
# FriendshipNotification.with(post: @post).deliver_later(current_user)
# FriendshipNotification.with(post: @post).deliver(current_user)

class FriendshipNotification < Noticed::Base
  deliver_by :database
  deliver_by :action_cable, format: :to_action_cable

  # On attend un paramètre :message (chaîne de caractères)
  param :message, :asker_id, :receiver_id

  # Après la livraison, nous diffusons la notification via Turbo Streams
  after_deliver :broadcast_notification

  def to_database
    { message: params[:message], asker_id: params[:asker_id], receiver_id: params[:receiver_id] }
  end

  def to_action_cable
    { title: "New friend invite", message: params[:message], asker_id: params[:asker_id], receiver_id: params[:receiver_id], id: record.id }
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
