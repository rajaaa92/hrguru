class Hrguru.Views.Dashboard.Filters extends Backbone.View

  el: '#filters'

  events:
    'change #highlight-ending' : 'highlightEndingChanged'
    'change #show-next' : 'showNextChanged'
    'change #highlight-not-billable' : 'highlightNotBillableChanged'

  initialize: (@projects, @roles) ->

  render: ->
    @initializeRoleFilter()
    @initializeProjectFilter()
    @setupForCheckboxStates()

  initializeProjectFilter: ->
    projects_selectize = @$('input[name=projects]').selectize
      plugins: ['remove_button']
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'name'
      options: @projects.toJSON()
      onItemAdd: @filterProjects
      onItemRemove: @filterProjects
    @projects_selectize = projects_selectize[0].selectize

  initializeRoleFilter: ->
    roles_selectize = @$('input[name=roles]').selectize
      plugins: ['remove_button']
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'priority'
      options: @roles.toJSON()
      onItemAdd: @filterRoles
      onItemRemove: @filterRoles
    @roles_selectize = roles_selectize[0].selectize

  setupForCheckboxStates: ->
    $('#highlight-ending').trigger 'change'
    $('#show-next').trigger 'change'
    $('#highlight-not-billable').trigger 'change'

  filterProjects: =>
    Backbone.trigger('projects:toggleVisibility', @projects_selectize.items)

  filterRoles: =>
    Backbone.trigger('roles:toggleVisibility', @roles_selectize.items)

  highlightEndingChanged: (event) ->
    Backbone.trigger('memberships:highlightEnding', event.currentTarget.checked)

  showNextChanged: (event) ->
    Backbone.trigger('memberships:showNext', event.currentTarget.checked)

  highlightNotBillableChanged: (event) ->
    Backbone.trigger('memberships:highlightNotBillable', event.currentTarget.checked)
