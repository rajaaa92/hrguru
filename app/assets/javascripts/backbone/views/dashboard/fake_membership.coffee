class Hrguru.Views.Dashboard.FakeMembership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'fake-membership'
  template: JST['dashboard/fake_membership']

  serializeData: ->
    user = @model.get('virtual_user').toJSON()
    role = @options.roles.get(@model.get('role_id')).toJSON()
    $.extend(super, { user: user, role: role })
