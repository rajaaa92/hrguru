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
        defaultOption:
          label: "no role"
          value: null

  onRender: ->
    @stickit()
    role = @model.get("role")
    @$el.find('.roles').val(role._id) if role

  addInputHandler: ->
    Backbone.Stickit.addHandler
      selector: ".phone,.roles,.employment"
      events: ['change']
      onSet: 'update'

  addDateHandler: ->
    Backbone.Stickit.addHandler
      selector: '.date_picker'
      events: ['hide']
      onSet: 'update'

  update: (val, options) ->
    attr_name = options.observe
    attr_value = @model.get(attr_name)
    unless (attr_value == val) || (!attr_value && !val)
      attr = {}
      attr[attr_name] = val
      @model.save(attr, { patch: true })
