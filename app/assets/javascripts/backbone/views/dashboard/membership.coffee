class Hrguru.Views.Dashboard.Membership extends Marionette.ItemView

  className: 'membership'
  template: JST['dashboard/membership']

  events:
    'click .remove' : 'finishMembership'

  serializeData: ->
    user = @options.users.get(@model.get('user_id')).toJSON()
    $.extend(super, { user: user })


  finishMembership: (event) ->
    event.preventDefault()
    event.stopPropagation()

    @$membership_entry = $(event.currentTarget)
    project = @$membership_entry.parents('td').data('project')
    role = @$membership_entry.parents('td').data('role')
    @user = @$membership_entry.parent('.entry').data('value')
    membership = @memberships.findWhere(project_id: project, role_id: role, user_id: @user)

    to = moment(gon.currentTime).add(moment().diff(@now))
    membership.save({ to: to.format() }, { patch: true, success: @membershipFinished })

  membershipFinished: =>
    input = @$membership_entry.parents('.selectize-control').siblings('input.selectized')
    input[0].selectize.removeItem(@user)

