class Hrguru.Views.Dashboard.FakeMembership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'fake-membership'
  template: JST['dashboard/fake_membership']

  initialize: ->
    super()
    @user = @model.get('virtual_user')
