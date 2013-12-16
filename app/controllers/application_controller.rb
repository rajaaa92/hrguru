class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :connect_github

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def current_user
    @decorated_cu ||= super.decorate if super.present?
  end

  def connect_github
    if signed_in? && !current_user.github_connected?
      redirect_to github_connect_path
    end
  end
end
