localModel = ($) ->
  class LocalModel
    constructor: (options = {}) ->
      @fetchUrl = options.fetchUrl ? options.url
      @saveUrl = options.saveUrl ? options.url
      @$el = @jQel = options.$el ? $(options.el)
      @model = {}

    render: () ->
      @$el.html(@model.value)
      return @

    fetch: (data = {}) ->
      $.getJSON @fetchUrl, data, (response)=>
        @model = response
        @render()
      return @

    save: (model = {}, extraData = {}) ->
      data = mergeObjs(@model, model, extraData)
      data = {model: JSON.stringify(data)}
      $.post @saveUrl, data, (response) =>
        model = if response.model? then response.model else model
        @set(model)
      return @

    set: (model = {}) ->
      $.extend(@model, model)
      @render()
      return @model

    get: (key) ->
      if typeof key isnt 'undefined'
        return @model[key]
      return @model

    mergeObjs = (objs...) ->
      newObj = {}
      for obj in objs
        for attr, val of obj
          newObj[attr] = val
      return newObj


  LocalModel.extend = (protoProps = {}) ->
    parent = @
    child = ->
      parent.apply(@, arguments)
    $.extend(child, parent)
    Surrogate = ->
      @constructor = child
      return
    Surrogate.prototype = parent.prototype
    child.prototype = new Surrogate
    $.extend(child.prototype, protoProps)
    child.__super__ = parent.prototype
    return child

  return LocalModel

# Support for RequireJS
if typeof define is "function" and typeof define.amd is "object" and define.amd
  define 'LocalModel', ['jquery'], ($) ->
    return localModel($)

# In browser
else
  window.LocalModel = localModel($)

