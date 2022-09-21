class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :authenticate_user!
  layout :layout

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname,:phone_number,:age,:role_ids ])
  end

  def layout
    !devise_controller? && "application"
  end

end
