class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_notifications

  private

  def set_notifications
    @notifications = current_user&.notifications.order(created_at: :desc)
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
