class NotificationsController < ApplicationController
  before_action :index, if: :user_signed_in?

  def index
    @notifications = current_user.notifications
      .where.not(type: "MessageNotification")
      .order(created_at: :desc)
    @notifications.mark_as_read!
  end
end
