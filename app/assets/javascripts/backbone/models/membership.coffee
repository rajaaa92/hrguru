class Hrguru.Models.Membership extends Backbone.Model

class Hrguru.Collections.Memberships extends Backbone.Collection
  model: Hrguru.Models.Membership
  url: Routes.memberships_path()

  for_project: (project_id, roles) ->
    base = @where(project_id: project_id)
    additional = Array()

    roles.each (role) ->
      with_role = _.select(base, (membership) -> membership.get('role_id') == role.get('id'))
      if with_role.length == 0
        user = UserFactory.basedOnRole(role)
        attributes = { role_id: role.get('id'), fake: true, virtual_user: user }
        membership = new Hrguru.Models.Membership(attributes)
        additional.push(membership)

    new Hrguru.Collections.Memberships(base.concat(additional))
