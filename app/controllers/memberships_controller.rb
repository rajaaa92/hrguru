class MembershipsController < ApplicationController
  expose(:membership, attributes: :membership_params)
  expose(:memberships)
  expose(:projects)
  expose(:roles)
  expose(:users)

  def create
    if membership.save
      redirect_to memberships_path, notice: "Membership created!"
    else
      render :new
    end
  end

  protected

  def membership_params
    params.require(:membership).permit(:from, :to, :project_id, :user_id, :role_id)
  end
end
