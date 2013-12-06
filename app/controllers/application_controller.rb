class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def current_user
    @decorated_cu ||= super.decorate if super.present?
  end
end
