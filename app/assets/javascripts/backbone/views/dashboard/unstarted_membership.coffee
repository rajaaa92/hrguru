class Hrguru.Views.Dashboard.UnstartedMembership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'membership unstarted hide'
  template: JST['dashboard/unstarted_membership']

  initialize: ->
    super()
    @user = @options.users.get(@model.get('user_id'))
    @listenTo(Backbone, 'memberships:showNext', @showNext)

  showNext: (state) ->
    @$el.toggleClass('hide', !state) unless @model.started()
