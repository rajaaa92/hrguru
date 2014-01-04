class Hrguru.Views.ProjectsShow extends Backbone.View
  el: '#main-container'

  initialize: ->
    @timeline = @$('.timeline').timeline(gon.events)
    @$el.after @timeline
