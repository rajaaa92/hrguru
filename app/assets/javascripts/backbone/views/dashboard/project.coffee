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

  onRender: ->
    @$('.new-membership input').selectize
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @options.itemViewOptions.users.toJSON()
      onItemAdd: @newMembership
      render:
        option: (item, escape) => @completionTemplate(item)

  newMembership: (value, $item) =>
    from = moment(gon.currentTime).add(moment().diff(@now))
    attributes = { project_id: project, role_id: role, user_id: value, from: from }
    @memberships.create(attributes, { wait: true })
