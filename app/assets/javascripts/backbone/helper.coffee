class Hrguru.Helper

  constructor: (options)->
    @time_now = moment()
    @server_time = gon.currentTime

    @setMessengerOptions()
    @addViewHelpers()

  currentTime: ->
    moment(@server_time).add(moment().diff(@time_now))

  addViewHelpers: ->
    HAML.globals = ->
      globals = {}

      for key, template of JST
        if helper = key.match /^helpers\/(.+)/
          globals[helper[1]] = template

      facadeCall = (helper, params) ->
        globals[helper] = (values...) ->
          JST["helpers/#{helper}"](values.reduce (x, value) ->
            param = params[values.indexOf value]
            x[param]= value
            x
          , {})

      facadeCall 'link_to', ['name', 'link']
      facadeCall 'icon', ['name']
      globals

  setMessengerOptions: ->
    Messenger.options =
      extraClasses: 'messenger-fixed messenger-on-top messenger-on-right'
      theme: 'flat'
      messageDefaults:
        hideAfter: 5
