class Hrguru.Views.DashboardIndex extends Backbone.View

  el: '#main-container'
  completionItem: JST['dashboard/completion']

  initialize: ->
    @users = new Hrguru.Collections.Users(gon.users)
    @showAutocomplation()

  showAutocomplation: ->
    @$('#projects-users input').selectize
      plugins: ['remove_button']
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @users.toJSON()
      render:
        item: (item, escape) ->
          $('<div>', class: 'entry', text: item.name)[0].outerHTML
        option: (item, escape) => @completionItem(item)

