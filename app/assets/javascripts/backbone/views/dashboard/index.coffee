class Hrguru.Views.DashboardIndex extends Marionette.View

  el: '#main-container'

  ui:
    table: '#projects-users'
    editPopups:'#edit-membership-popups'

  initialize: ->
    @now = moment()
    @users = new Hrguru.Collections.Users(gon.users)
    @memberships = new Hrguru.Collections.Memberships(gon.memberships)
    @projects = new Hrguru.Collections.Projects(gon.projects)
    @roles = new Hrguru.Collections.Roles(gon.roles)

    @render()

  render: ->
    @bindUIElements()
    @fillTable()
    filters_view = new Hrguru.Views.Dashboard.Filters(@projects, @roles)
    filters_view.render()
    @fillEditPopups()

  fillTable: ->
    @projects.each (project) =>
      view = new Hrguru.Views.Dashboard.Project
        model: project
        memberships: @memberships
        roles: @roles
        users: @users
      @ui.table.append(view.render().$el)

  fillEditPopups: ->
    @memberships.each (membership) =>
