class Hrguru.Helper

  constructor: (options)->
    @addViewHelpers()

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
