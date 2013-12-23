class Hrguru.Views.RolesIndex extends Backbone.View
  el: '#main-container'

  events:
    'click #add-role': 'addItem'

  initialize: ->
    @rolesListView = new Marionette.CollectionView
      collection: new Hrguru.Collections.Roles(gon.roles)
      itemView: Hrguru.Views.RolesRow
      emptyView: Hrguru.Views.RolesEmptyRow
      el: @$('ul#roles')
      tagName: 'ul'

    @rolesListView.getIds = ->
      _.map @collection.models, (model) -> model.get('id')

    @rolesListView.equalIds = (aIds) ->
      @getIds().every (elem, i) -> elem is aIds[i]

    @rolesListView.collection.comparator = 'priority'

    @rolesListView.on 'itemview:collection:sort', ->
      idsBefore = @getIds()
      @collection.sort()
      @render() unless @equalIds(idsBefore)

    @rolesListView.render()

  addItem: (event) ->
    event.preventDefault()
    $input = $('#name')
    role = new Hrguru.Models.Role()
    role.save(name: $input.val(),
      success: =>
        $input.val("")
        @rolesListView.collection.add role
    )
