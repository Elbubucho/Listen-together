# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def update_resource(resource, params)
    update_params = params.except(:current_password)
    if params[:password].blank?
      resource.update_without_password(update_params)
    else
      resource.update_with_password(update_params)
    end
  end

  def after_update_path_for(resource)
    if params[:custom_profile_edit]
      user_path(current_user)
    else
      super
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar, :bio])
  end

  def account_update_params
    params.require(:user).permit(:avatar, :bio, :username)
  end

end
