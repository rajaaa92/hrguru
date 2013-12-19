class Hrguru.Views.Dashboard.Membership extends Marionette.ItemView

  className: 'membership'
  template: JST['dashboard/membership']

  events:
    'click .remove' : 'finishMembership'

  initialize: ->
    @now = moment()
    @listenTo(Backbone, 'roles:toggleVisibility', @toggleVisibility)

  serializeData: ->
    user = @options.users.get(@model.get('user_id')).toJSON()
    $.extend(super, { user: user })

  finishMembership: (event) ->
    to = moment(gon.currentTime).add(moment().diff(@now))
    @model.save({ to: to }, { patch: true, success: => @close() })

  toggleVisibility: (ids) ->
    if ids.length == 0
      @$el.removeClass('hide')
      return

    show = @model.get('role_id') in ids
    @$el.toggleClass('hide', !show)
