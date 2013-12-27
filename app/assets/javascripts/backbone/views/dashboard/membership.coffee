class Hrguru.Views.Dashboard.Membership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'membership'
  template: JST['dashboard/membership']

  events:
    'click .remove' : 'finishMembership'

  initialize: ->
    super()
    @user = @options.users.get(@model.get('user_id'))

  finishMembership: (event) ->
    to = H.currentTime().format()
    @model.save({ to: to }, { patch: true, success: @finishedMembership, error: @onMembershipError })

  finishedMembership: =>
    @trigger('membership:finished')
    @close()

  onMembershipError: (membership, request) =>
    error_massage = request.responseJSON.errors.project[0]
    Messenger().error(error_massage)
