require 'rollbar/rails'

Rollbar.configure do |config|
  config.access_token = ENV['SECRET_KEY_BASE']
  config.exception_level_filters.merge!('Mongoid::DocumentNotFound' => 'ignore', 'ActionController::RoutingError' => 'ignore')

  if Rails.env.test? || Rails.env.development?
     config.enabled = false
  end
end
