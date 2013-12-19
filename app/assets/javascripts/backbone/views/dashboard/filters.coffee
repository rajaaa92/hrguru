class Hrguru.Views.Dashboard.Filters extends Backbone.View

  el: '#filters'

  initialize: ->
    @projects = @options.projects
    @roles = @options.roles

  render: ->
    @initializeRoleFilter()
    @initializeProjectFilter()

  initializeProjectFilter: ->
    projects_selectize = @$('input[name=projects]').selectize
      plugins: ['remove_button']
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
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
      options: @roles.toJSON()
      onItemAdd: @filterRoles
      onItemRemove: @filterRoles
    @roles_selectize = roles_selectize[0].selectize

  filterProjects: =>
    Backbone.trigger('projects:toggleVisibility', @projects_selectize.items)

  filterRoles: =>
    Backbone.trigger('roles:toggleVisibility', @roles_selectize.items)
