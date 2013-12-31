class Hrguru.Views.Dashboard.Membership extends Hrguru.Views.Dashboard.BaseMembership

  className: -> @cssClasses()
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

  cssClasses: ->
    base_class = 'membership'
    return base_class unless @model.get('to')?

    classes = Array(base_class)
    to = moment(@model.get('to'))
    left = _.find [1, 7, 14, 30], (day) -> H.currentTime().add(days: day) > to
    classes.push("left-#{left}") if left?
    classes.join(' ')
