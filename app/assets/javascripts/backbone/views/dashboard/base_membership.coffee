class Hrguru.Views.Dashboard.BaseMembership extends Marionette.ItemView

  initialize: ->
    @listenTo(Backbone, 'roles:toggleVisibility', @toggleVisibility)
    @role = @options.roles.get(@model.get('role_id'))

  serializeData: ->
    $.extend(super, { user: @user.toJSON(), role: @role.toJSON() })

  toggleVisibility: (ids) ->
    if ids.length == 0
      @$el.removeClass('hide')
      return

    show = @model.get('role_id') in ids
    @$el.toggleClass('hide', !show)
