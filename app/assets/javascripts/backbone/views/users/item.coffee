class Hrguru.Views.UsersRow extends Backbone.Marionette.ItemView
  tagName: 'tr'
  template: JST['users/row']

  bindings:
    '.name': 'name'
    '.intern_start': 'intern_start'
    '.intern_end': 'intern_end'
    '.recruited': 'recruited'
    '.employment': 'employment'
    '.phone': 'phone'
    '.roles':
      observe: 'role'
      selectOptions:
        collection: -> gon.roles
        labelPath: 'name'
        valuePath: '_id'

  onRender: ->
    @stickit()
