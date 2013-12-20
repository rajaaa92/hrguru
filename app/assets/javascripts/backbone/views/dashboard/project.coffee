class Hrguru.Views.Dashboard.Project extends Marionette.CompositeView

  className: 'project'
  template: JST['dashboard/project']
  completionTemplate: JST['dashboard/completion']

  itemViewContainer: '.memberships'
  itemViewOptions: ->
    users: @users
    roles: @roles

  initialize: ->
    @now = moment()
    $.extend(@, @options)
    @resetCollection()
    @on('itemview:membership:finished', @removeMembership)
    @listenTo(Backbone, 'projects:toggleVisibility', @toggleVisibility)

  getItemView: (item) ->
    name = if item.get('fake') then 'FakeMembership' else 'Membership'
    Hrguru.Views.Dashboard[name]

  resetCollection: ->
    collection = @memberships.for_project(@model.get('id'), @roles)
    @collection.reset(collection.models) if @collection?
    @collection ||= collection

  removeMembership: (item_view) ->
    @memberships.remove(item_view.model)
    @resetCollection()

  onRender: ->
    selectize = @$('.new-membership input').selectize
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @options.users.toJSON()
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
    role = @options.users.get(value).get('role_id')
    attributes = { project_id: @model.get('id'), role_id: role, user_id: value, from: from }
    @memberships.create attributes,
      wait: true
      success: @membershipCreated
      error: @membershipError

  membershipCreated: =>
    @selectize.clear()
    @selectize.close()
    @resetCollection()

  membershipError: =>
    #TODO
