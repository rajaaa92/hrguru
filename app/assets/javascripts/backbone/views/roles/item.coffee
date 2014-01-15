class Hrguru.Views.RolesEmptyRow extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: JST['roles/empty_row']

class Hrguru.Views.RolesRow extends Backbone.Marionette.ItemView
  tagName: 'li'
  id: -> "role_#{@model.get('id')}"
  template: JST['roles/row']

  initialize: -> @addInputHandler()

  bindings:
    '.name': 'name'
    '.color': 'color'
    '.billable': 'billable'

  events:
    'click .destroy': 'destroy'

  onRender: ->
    @stickit()

  addInputHandler: ->
    Backbone.Stickit.addHandler
      selector: '.name,.color,.billable'
      events: ['change']
      onSet: 'update'

  update: (val, options) ->
    attr_name = options.observe
    @input = @$(".#{attr_name}")
    attr = {}
    attr[attr_name] = val
    @model.save(attr,
      patch: true
      success: => @hideError()
      error: (model, xhr) => @showError(xhr.responseJSON.errors)
    )

  destroy: (event) ->
    event.preventDefault()
    if confirm "Are you sure?"
      @model.destroy
        wait: true
        error: ->
          alert "Cannot destroy role... Try later."

  showError: (errorsJSON = {}) ->
    for attr, errors of errorsJSON
      Messenger().error("#{attr} #{msg}") for msg in errors

    @input.wrap("<div class='has-error'></div>") unless @hasError()

  hideError: ->
    @input.unwrap() if @hasError()

  hasError: ->
    @input.parent().is('div.has-error')
