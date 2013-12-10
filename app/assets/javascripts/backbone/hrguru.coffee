#= require_self
#= require_tree ./templates
#= require_tree ./views
#= require_tree ./models

window.Hrguru =
  Models: {}
  Collections: {}
  Views: {}

  init: ->
    view_name = $('body').data('view')
    @current_view = new Hrguru.Views[view_name]() if Hrguru.Views[view_name]?

$ ->
  Hrguru.init()
