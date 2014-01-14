class Hrguru.Views.Dashboard.Project extends Marionette.CompositeView

  className: 'project'
  template: JST['dashboard/project']
  completionTemplate: JST['dashboard/completion']

  itemViewContainer: '.memberships'
  itemViewOptions: ->
    users: @users
    roles: @roles

  initialize: ->
    $.extend(@, @options)
    @resetCollection()
    @on('itemview:membership:finished', @removeMembership)
    @listenTo(Backbone, 'projects:toggleVisibility', @toggleVisibility)

  getItemView: (item) ->
    name = switch
      when item.get('fake') then 'FakeMembership'
      when !item.started() then 'UnstartedMembership'
      else 'Membership'
    Hrguru.Views.Dashboard[name]

  resetCollection: ->
    collection = @memberships.forProject(@model.get('id'), @roles)
    @collection.reset(collection.models) if @collection?
    @collection ||= collection
    @refreshSelectizeOptions()

  removeMembership: (item_view) ->
    @memberships.remove(item_view.model)
    @resetCollection()
    user_name = item_view.user.get('name')
    project_name = @model.get('name')
    Messenger().success("#{user_name} has been removed from #{project_name}")

  onRender: ->
    selectize = @$('.new-membership input').selectize
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @selectize_options
      onItemAdd: @newMembership
      render:
        option: (item, escape) => @completionTemplate(item)
    @selectize = selectize[0].selectize

  refreshSelectizeOptions: ->
    selected = _.compact(@collection.pluck('user_id'))
    to_select = @users.select (model) -> !(model.get('id') in selected)
    @selectize_options = to_select.map (model) -> model.toJSON()
    if @selectize?
      @selectize.clearOptions()
      @selectize.load (callback) => callback(@selectize_options)

  toggleVisibility: (ids) ->
    show = ids.length == 0 || @model.get('id') in ids
    @$el.toggleClass('hide', !show)

  newMembership: (value, $item) =>
    from = H.currentTime().format()
    role = @options.users.get(value).get('role_id')
    billable = @options.roles.get(role).get('billable')
    attributes = { project_id: @model.get('id'), role_id: role, user_id: value, from: from, billable: billable }
    @memberships.create attributes,
      wait: true
      success: @membershipCreated
      error: @membershipError

  membershipCreated: (membership) =>
    @selectize.clear()
    @resetCollection()
    user_name = @users.get(membership.get('user_id')).get('name')
    project_name = @model.get('name')
    Messenger().success("#{user_name} has been added to #{project_name}")

  membershipError: (membership, request)=>
    @selectize.clear()
    error_massage = request.responseJSON.errors.project[0]
    Messenger().error(error_massage)
