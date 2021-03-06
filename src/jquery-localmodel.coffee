localModel = ($) ->
  class LocalModel
    # Create a new LocalModel object
    #
    # `options`:
    #   * `fetchUrl` Server GET endpoint
    #   * `saveUrl` Server POST endpoint
    #   * `url` Unique server endpoint if supports both GET and POST methods
    #   * `el` jQuery selector that matches the nodes where contents are rendered
    constructor: (options = {}) ->
      @fetchUrl = options.fetchUrl ? options.url
      @saveUrl = options.saveUrl ? options.url
      @$el = @jQel = options.$el ? $(options.el)
      @model = {}

    #Set the html contents in the set this.$el
    render: () ->
      @$el.html(@model.value)
      return @

    # GET the data from this.fetchUrl and store the response into this.model
    #   * `data` Sent to the server as query string
    fetch: (data = {}) ->
      $.getJSON @fetchUrl, data, (response)=>
        @model = response
        @render()
      return @

    # POST this.model to this.saveUrl. this.model is JSON serialized under a `model` parameter,
    # and the request is made with a application/x-www-form-urlencoded MIME type.
    # If the server response contains `model` key, `model` will be merged into this.model
    #   * `model` Merged into this.model before POST
    #   * `extraData` Sent to server but not merged into this.model
    save: (model = {}, extraData = {}) ->
      $.extend(@model, model)
      data = mergeObjs(@model, extraData)
      data = {model: JSON.stringify(data)}
      $.post @saveUrl, data, (response) =>
        model = if response.model? then response.model else {}
        @set(model)
      return @

    # Merge an object into this.model and then trigger this.render()
    #   * `model` Merged into this.model
    set: (model = {}) ->
      $.extend(@model, model)
      @render()
      return @model

    # Get a the value of a single key of this.model, or the entire model
    get: (key) ->
      if typeof key isnt 'undefined'
        return @model[key]
      return @model

    # Helper function to merge multiple objects
    mergeObjs = (objs...) ->
      newObj = {}
      for obj in objs
        for attr, val of obj
          newObj[attr] = val
      return newObj

  # Helper function to correctly set up the prototype chain, for subclasses.
  LocalModel.extend = (protoProps = {}) ->
    parent = @
    # The constructor function for the new subclass is the `parent`'s constructor
    child = ->
      parent.apply(@, arguments)
    $.extend(child, parent)
    # Set the prototype chain to inherit from `parent`, without calling
    # `parent`'s constructor function.
    Surrogate = ->
      @constructor = child
      return
    Surrogate.prototype = parent.prototype
    child.prototype = new Surrogate
    # Add prototype properties to the subclass
    $.extend(child.prototype, protoProps)
    # Set a convenience property in case the parent's prototype is needed later.
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

