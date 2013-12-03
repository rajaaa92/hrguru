require 'rollbar/rails'

Rollbar.configure do |config|
  config.access_token = '43abef20075143f6832de97b8512eace'
  config.exception_level_filters.merge!('Mongoid::DocumentNotFound' => 'ignore', 'ActionController::RoutingError' => 'ignore')

  if Rails.env.test? || Rails.env.development?
     config.enabled = false
  end
end
