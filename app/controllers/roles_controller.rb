class RolesController < ApplicationController
  respond_to :json

  expose(:role, attributes: :role_params)
  expose(:roles) { Role.all }

  def index
    gon.rabl as: 'roles'
  end

  def create
    if role.save
      redirect_to role, notice: "Role created!"
    else
      render :new
    end
  end

  def update
    if role.save
      redirect_to role, alert: "Role updated!"
    else
      render :edit
    end
  end

  def destroy
    redirect_to(roles_url, alert: "Role deleted!") if role.destroy
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
end
