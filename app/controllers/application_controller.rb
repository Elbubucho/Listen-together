class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_notifications

  private

  def set_notifications
    @notification = current_user.notifications.order(created_at: :desc)
  end
end
