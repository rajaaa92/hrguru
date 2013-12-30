class RolesController < ApplicationController
  respond_to :json

  expose(:role, attributes: :role_params)
  expose(:roles) { Role.all }

  def index
    gon.rabl as: 'roles'
  end

  def create
    if role.save
      render :role, status: :created
    else
      respond_with role
    end
  end

  def update
    if role.save
      render :role
    else
      respond_with role
    end
  end

  def destroy
    if role.destroy
      respond_with
    else
      render json: {}, status: :not_found
    end
  end

  def sort
    params[:role].each_with_index do |id, index|
      Role.where(id: id).update_all(priority: index + 1)
    end
    render json: {}
  end

  private

  def role_params
    params.require(:role).permit(:name, :color)
  end
end
