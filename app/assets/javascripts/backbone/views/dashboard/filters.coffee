class Hrguru.Views.Dashboard.Filters extends Backbone.View

  el: '#filters'

  initialize: ->
    @projects = @options.projects
    @roles = @options.roles

  render: ->
    @initializeRoleFilter()
    @initializeProjectFilter()

  initializeProjectFilter: ->
    @$('input[name=projects]').selectize
      plugins: ['remove_button']
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @projects.toJSON()

  initializeRoleFilter: ->
    @$('input[name=roles]').selectize
      plugins: ['remove_button']
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @roles.toJSON()
