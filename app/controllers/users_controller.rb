class UsersController < ApplicationController
  expose_decorated(:user, attributes: :user_params)
  expose(:users) { User.by_name.decorate }
  expose(:roles) { Role.all }
  expose(:projects) { Project.all }

  def index
    gon.rabl as: 'users'
    gon.roles = roles
  end

  def update
    if user.save
      render json: {}
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def show
    @membership = Membership.new(user: user, role: user.role)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :intern_start, :intern_end, :recruited, :employment, :phone, :location)
  end
end
