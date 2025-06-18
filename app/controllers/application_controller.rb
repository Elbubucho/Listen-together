class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_notifications, if: :user_signed_in?
  before_action :set_current_user

  private

  def set_notifications
    @notifications = current_user&.notifications.order(created_at: :desc)
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def set_current_user
    Current.user = current_user
  end
end
