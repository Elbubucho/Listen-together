# To deliver this notification:
#
# MessageNotification.with(post: @post).deliver_later(current_user)
# MessageNotification.with(post: @post).deliver(current_user)

class MessageNotification < Noticed::Base
  deliver_by :database
  deliver_by :action_cable, format: :to_action_cable

  # On attend un paramètre :message (chaîne de caractères)
  param :message

  # Après la livraison, nous diffusons la notification via Turbo Streams
  after_deliver :broadcast_notification

  def to_database
    { message: params[:message] }
  end

  def to_action_cable
    { title: "New message", message: params[:message], id: record.id }
  end

  private

  def broadcast_notification
    recipient.broadcast_replace_later_to(
      "message_#{recipient.id}_indicator",
      target: "message-indicator",
      partial: "notifications/message_indicator",
      locals: { user: recipient }
    )
  end
end
