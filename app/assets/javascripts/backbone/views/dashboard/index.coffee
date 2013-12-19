class Hrguru.Views.DashboardIndex extends Backbone.View

  el: '#main-container'

  initialize: ->
    @now = moment()
    @users = new Hrguru.Collections.Users(gon.users)
    @memberships = new Hrguru.Collections.Memberships(gon.memberships)
    @projects = new Hrguru.Collections.Projects(gon.projects)
    @roles = new Hrguru.Collections.Memberships(gon.roles)

    @render()

  render: ->
    @fillTable()
    filters_view = new Hrguru.Views.Dashboard.Filters(projects: @projects, roles: @roles)
    filters_view.render()

  fillTable: ->
    @projects.each (project) =>
      memberships = @memberships.for_project(project.get('id'))
      view = new Hrguru.Views.Dashboard.Project
        model: project
        collection: memberships
        itemViewOptions:
          users: @users
      @$('#projects-users').append(view.render().$el)
