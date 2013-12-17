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
      attrObj = {}
      attrObj[attr_name] = val
      @save(attrObj, attr_name)

  save: (attrObj, attr_name) ->
    $input = @$el.find(".#{attr_name}")
    that = this
    @model.save(attrObj,
      patch: true
      success: (model, response, options) ->
        that.hideError($input)
        that.showPopover($input, 'updated!')
      error: (model, response, options) ->
        errors = response.responseJSON.errors
        msg = _.first(errors[attr_name])
        that.showError($input)
        that.showPopover($input, msg)
    )

  showError: ($element) ->
    $element.wrap("<div class='has-error'></div>") unless @hasError($element)

  hideError: ($element) ->
    $element.unwrap() if @hasError($element)

  hasError: ($element) ->
    $element.parent().is('div.has-error')

  showPopover: ($element, msg) ->
    $element
      .popover
        html : true
        placement: 'top'
        content: msg
        trigger: 'manual'
      .on 'shown.bs.popover', ->
        setTimeout ->
          $element.popover('destroy')
        , 3000
      .popover('show')
