class Hrguru.Models.Membership extends Backbone.Model

  started: ->
    H.currentTime() > moment(@get('from'))

  daysToEnd: ->
    return null unless @get('to')?
    moment(@get('to')).diff(H.currentTime(), 'days')

class Hrguru.Collections.Memberships extends Backbone.Collection
  model: Hrguru.Models.Membership
  url: Routes.memberships_path()

  forProject: (project_id, roles) ->
    result = Array()
    base = @select (m) -> m.get('project_id') == project_id && m.started()

    roles.each (role) ->
      with_role = _.select base, (m) -> m.get('role_id') == role.get('id')
      if with_role.length == 0
        user = UserFactory.basedOnRole(role)
        attributes = { role_id: role.get('id'), fake: true, virtual_user: user }
        with_role = Array(new Hrguru.Models.Membership(attributes))
      result.push.apply(result, with_role)

    new Hrguru.Collections.Memberships(result)
