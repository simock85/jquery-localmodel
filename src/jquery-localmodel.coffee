localModel = ($) ->
  class LocalModel
    ###
    Create a new LocalModel object

    @param {Object} options Options object
    options:
      * fetchUrl Server GET endpoint
      * saveUrl Server POST endpoint
      * url Unique server endpoint if supports both GET and POST methods
      * el jQuery selector that matches the nodes where contents are rendered
    ###
    constructor: (options = {}) ->
      @fetchUrl = options.fetchUrl ? options.url
      @saveUrl = options.saveUrl ? options.url
      @$el = @jQel = options.$el ? $(options.el)
      @model = {}

    ###
    Set the html contents in the set this.$el
    ###
    render: () ->
      @$el.html(@model.value)
      return @

    ###
    GET the data from this.fetchUrl and store the response into this.model

    @param {Object} data Sent to the server as query string
    ###
    fetch: (data = {}) ->
      $.getJSON @fetchUrl, data, (response)=>
        @model = response
        @render()
      return @

    ###
    POST this.model to this.saveUrl. this.model is JSON serialized under a `model` parameter,
    and the request is made with a application/x-www-form-urlencoded MIME type.
    If the server response contains `model` key, `model` will be merged into this.model

    @param {Object} model This object is merged into this.model before POST
    @param {Object} extraData Extra data sent to server but not merged into this.model
    ###
    save: (model = {}, extraData = {}) ->
      $.extend(@model, model)
      data = mergeObjs(@model, extraData)
      data = {model: JSON.stringify(data)}
      $.post @saveUrl, data, (response) =>
        model = if response.model? then response.model else {}
        @set(model)
      return @

    ###
    Merge an object into this.model and then trigger this.render()

    @param {Object} model This object is merged into this.model
    ###
    set: (model = {}) ->
      $.extend(@model, model)
      @render()
      return @model

    ###
    Get a the value of a single key of this.model, or the entire model
    ###
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

