class Hrguru.Views.RolesIndex extends Backbone.View
  el: '#main-container'

  initialize: ->
    @rolesListView = new Marionette.CollectionView
      collection: new Hrguru.Collections.Roles(gon.roles)
      itemView: Hrguru.Views.RolesRow
      emptyView: Hrguru.Views.RolesEmptyRow
      el: @$('ul#roles')
      tagName: 'ul'

    @rolesListView.render()
