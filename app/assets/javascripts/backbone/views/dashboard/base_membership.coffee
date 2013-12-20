class Hrguru.Views.Dashboard.BaseMembership extends Marionette.ItemView

  initialize: ->
    @listenTo(Backbone, 'roles:toggleVisibility', @toggleVisibility)

  toggleVisibility: (ids) ->
    if ids.length == 0
      @$el.removeClass('hide')
      return

    show = @model.get('role_id') in ids
    @$el.toggleClass('hide', !show)
