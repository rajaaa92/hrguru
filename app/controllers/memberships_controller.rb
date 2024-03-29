class MembershipsController < ApplicationController
  respond_to :json, only: [:create, :update]

  expose(:membership, attributes: :membership_params)
  expose(:memberships)
  expose(:projects) { Project.decorate }
  expose(:roles) { Role.decorate }
  expose(:users) { User.decorate }

  before_action :set_users_gon, only: [:new, :create]

  def create
    if membership.save
      respond_to do |format|
        format.html { redirect_to memberships_path, notice: "Membership created!" }
        format.json { render :show }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: membership.errors }, status: 400 }
      end
    end
  end

  def update
    if membership.save
      respond_to do |format|
        format.html { redirect_to memberships_path, alert: "Membership updated!" }
        format.json { render :show }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { errors: membership.errors }, status: 400 }
      end
    end
  end

  def destroy
    redirect_to memberships_path, notice: "Membership deleted!" if membership.destroy
  end

  protected

  def membership_params
    params.require(:membership).permit(:from, :to, :project_id, :user_id,
                                       :role_id, :billable)
  end

  private

  def set_users_gon
    gon.rabl template: 'app/views/memberships/users', as: 'users'
  end
end
