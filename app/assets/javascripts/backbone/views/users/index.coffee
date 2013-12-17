class Hrguru.Views.UsersIndex extends Backbone.View
  el: '#main-container'

  initialize: ->
    tbodyView = new Marionette.CollectionView
      collection: new Hrguru.Collections.Users(gon.users)
      itemView: Hrguru.Views.UsersRow
      el: @$('table')
      tagName: 'tbody'

    tbodyView.render()

    @$('.icons a').tooltip()
