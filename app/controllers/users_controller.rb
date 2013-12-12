class UsersController < ApplicationController
  expose_decorated(:user)
  expose(:users) { User.all.decorate }

  def index
    gon.rabl as: 'users'
    gon.roles = Role.all
  end
end
