#= require_self
#= require_tree ./templates
#= require_tree ./views
#= require_tree ./models
#= require_tree ./lib
#= require ./helper

window.Hrguru =
  Models: {}
  Collections: {}
  Views:
    Dashboard: {}

  init: ->
    view_name = $('body').data('view')
    @current_view = new Hrguru.Views[view_name]() if Hrguru.Views[view_name]?

$ ->
  new Hrguru.Helper()
  Hrguru.init()
