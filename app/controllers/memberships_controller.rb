class MembershipsController < ApplicationController
  expose(:projects) { Project.all.includes(:memberships) }
  expose(:roles) { get_roles }


  protected

  def get_roles
    array = []
    Membership::ROLES.each do |role|
      max_count = projects.map{ |p| p.memberships.with_role(role).count }.max
      max_count.times do |i|
        array << projects.map{ |p| p.memberships.with_role(role).at(i) || Membership.new(project_id: p.id, role: role) }
      end
    end
    array
  end
end
