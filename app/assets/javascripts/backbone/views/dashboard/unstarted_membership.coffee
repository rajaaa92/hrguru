class Hrguru.Views.Dashboard.UnstartedMembership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'membership unstarted hide'
  template: JST['dashboard/unstarted_membership']

  initialize: ->
    super()
    @user = @options.users.get(@model.get('user_id'))
    @listenTo(Backbone, 'memberships:showNext', @showNext)
    @hidden_by_next = true
    @hidden_by_role = false

  showNext: (state) ->
    @hidden_by_next = !state
    @$el.toggleClass('hide', @hidden_by_next) unless @hidden_by_role

  toggleVisibility: (ids) ->
    @hidden_by_role = ids.length > 0 && !(@model.get('role_id') in ids)
    @$el.toggleClass('hide', @hidden_by_role) unless @hidden_by_next
