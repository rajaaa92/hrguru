class UsersController < ApplicationController
  expose_decorated(:user)
  expose_decorated(:users) { UserDecorator.new(User.all) }
end
