class Hrguru.Views.Dashboard.Membership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'membership'
  template: JST['dashboard/membership']

  events:
    'click .remove' : 'finishMembership'

  initialize: ->
    super()
    @user = @options.users.get(@model.get('user_id'))
    @now = moment()

  finishMembership: (event) ->
    to = moment(gon.currentTime).add(moment().diff(@now))
    @model.save({ to: to }, { patch: true, success: @finishedMembership })

  finishedMembership: =>
    @trigger('membership:finished')
    @close()
