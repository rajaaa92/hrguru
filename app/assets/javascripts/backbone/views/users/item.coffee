class Hrguru.Views.UsersRow extends Backbone.Marionette.ItemView
  tagName: 'tr'
  template: JST['users/row']

  initialize: ->
    @addInputHandler()
    @addDateHandler()

  bindings:
    '.intern_start': 'intern_start'
    '.intern_end': 'intern_end'
    '.recruited': 'recruited'
    '.employment': 'employment'
    '.phone': 'phone'
    '.roles':
      observe: 'role_id'
      selectOptions:
        collection: -> gon.roles
        labelPath: 'name'
        valuePath: '_id'

  onRender: ->
    @stickit()
    @$el.find('.roles').val(@model.get("role")._id)

  addInputHandler: ->
    Backbone.Stickit.addHandler
      selector: ".phone,.roles,.employment"
      events: ['change']
      onSet: 'update'

  addDateHandler: ->
    Backbone.Stickit.addHandler
      selector: '.date_picker'
      events: ['changeDate']
      onSet: 'update'

  update: (val, options) ->
    attr_name = options.observe
    unless @model.attributes[attr_name] == val
      attr = {}
      attr[attr_name] = val
      @model.save(attr, { patch: true })
