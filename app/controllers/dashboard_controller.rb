class DashboardController < ApplicationController
  expose(:projects) { Project.all.asc(:name) }
  expose(:roles)
  expose(:users) { User.all.decorate }

  def index
    gon.rabl 'app/views/dashboard/users', as: 'users'
  end
end
