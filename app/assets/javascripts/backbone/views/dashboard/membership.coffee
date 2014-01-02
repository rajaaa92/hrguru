class Hrguru.Views.Dashboard.Membership extends Hrguru.Views.Dashboard.BaseMembership

  className: 'membership'
  template: JST['dashboard/membership']

  events:
    'click .remove' : 'finishMembership'

  initialize: ->
    super()
    @user = @options.users.get(@model.get('user_id'))
    @listenTo(Backbone, 'memberships:highlightEnding', @highlightEnding)

  finishMembership: (event) ->
    to = H.currentTime().format()
    @model.save({ to: to }, { patch: true, success: @finishedMembership, error: @onMembershipError })

  finishedMembership: =>
    @trigger('membership:finished')
    @close()

  onMembershipError: (membership, request) =>
    error_massage = request.responseJSON.errors.project[0]
    Messenger().error(error_massage)

  highlightEnding: (state) ->
    return unless @model.started() && @model.daysToEnd()?

    left = _.find [1, 7, 14, 30], (day) => day >= @model.daysToEnd()
    @$el.toggleClass("left-#{left}", state) if left?
