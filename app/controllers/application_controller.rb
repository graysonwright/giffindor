require 'bunyan'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?

  protected

  def current_user
    @current_user ||= User.find session[:user_id]
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def user_signed_in?
    !!current_user
  end

  def authenticate_user!
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end

  after_action :log_action

  def log_action
    Bunyan.log request_name, request_params
  end

  def request_name
    "#{params[:controller]}##{params[:action]}"
  end

  def request_params
    params.except(:controller, :action).
      merge(ip: request.remote_ip,
            user_id: session[:user_id],
            status: response.status,
           )
  end
end
