class Hrguru.Views.RolesEmptyRow extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: JST['roles/empty_row']

class Hrguru.Views.RolesRow extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: JST['roles/row']

  bindings:
    '.name':
      observe: 'name'
      events: ['change']
      onSet: 'updateName'

  events:
    'click .destroy': 'destroy'

  onRender: ->
    @stickit()
    @input = @$('.name')

  updateName: (val) ->
    @model.save('name': val,
      patch: true
      success: => @hideError()
      error: => @showError()
    )

  destroy: (event) ->
    event.preventDefault()
    if confirm "Are you sure?"
      @model.destroy
        wait: true
        error: ->
          alert "Cannot destroy role... Try later."

  showError: ->
    @input.wrap("<div class='has-error'></div>") unless @hasError()

  hideError: ->
    @input.unwrap() if @hasError()

  hasError: ->
    @input.parent().is('div.has-error')
