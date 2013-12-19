class Hrguru.Views.Dashboard.Project extends Marionette.CompositeView

  className: 'project'
  template: JST['dashboard/project']
  completionTemplate: JST['dashboard/completion']

  itemView: Hrguru.Views.Dashboard.Membership
  itemViewContainer: '.memberships'
  itemViewOptions:
    users: -> @users

  initialize: ->
    @now = moment()
    @listenTo(Backbone, 'projects:toggleVisibility', @toggleVisibility)

  onRender: ->
    selectize = @$('.new-membership input').selectize
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @options.itemViewOptions.users.toJSON()
      onItemAdd: @newMembership
      render:
        option: (item, escape) => @completionTemplate(item)
    @selectize = selectize[0].selectize

  toggleVisibility: (ids) ->
    if ids.length == 0
      @$el.removeClass('hide')
      return

    show = @model.get('id') in ids
    @$el.toggleClass('hide', !show)

  newMembership: (value, $item) =>
    from = moment(gon.currentTime).add(moment().diff(@now))
    role = @options.itemViewOptions.users.get(value).get('role_id')
    attributes = { project_id: @model.get('id'), role_id: role, user_id: value, from: from }
    @collection.collection.create attributes,
      wait: true
      success: @membershipCreated
      error: @membershipError

  membershipCreated: =>
    @selectize.clear()
    @selectize.close()

  membershipError: =>
    #TODO
