class DashboardController < ApplicationController
  expose(:projects) { Project.all.asc(:name) }
  expose(:roles)
  expose(:users) { User.all.decorate }
  expose(:memberships) { Membership.active }

  def index
    gon.rabl 'app/views/dashboard/users', as: 'users'
    gon.rabl 'app/views/dashboard/memberships', as: 'memberships'
    gon.currentTime = Time.now
  end
end
