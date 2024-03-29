class Hrguru.Models.Membership extends Backbone.Model

  started: ->
    H.currentTime() > moment(@get('from'))

  daysToEnd: ->
    return null unless @get('to')?
    moment(@get('to')).diff(H.currentTime(), 'days')

  hasTechnicalRole: (role) ->
    role_name = role.get('name')
    return null unless role_name?
    _.contains ['developer', 'senior', 'junior', 'praktykant'], role_name

  hasTechnicalJuniorRole: (role) ->
    role_name = role.get('name')
    return null unless role_name?
    _.contains ['junior', 'praktykant'], role_name

  isBillable: ->
    @get('billable')

class Hrguru.Collections.Memberships extends Backbone.Collection
  model: Hrguru.Models.Membership
  url: Routes.memberships_path()

  forProject: (project_id, roles) ->
    result = Array()
    base = @where(project_id: project_id)
    started = _.select base, (m) -> m.started()
    unstarted = _.select base, (m) -> !m.started()

    roles.each (role) ->
      started_role = _.select started, (m) -> m.get('role_id') == role.get('id')
      unstarted_role = _.select unstarted, (m) -> m.get('role_id') == role.get('id')
      result.push.apply(result, unstarted_role) if unstarted_role.length > 0
      result.push.apply(result, started_role)

    new Hrguru.Collections.Memberships(result)
