(function() {
  var localModel,
    __slice = [].slice;

  localModel = function($) {
    var LocalModel;
    LocalModel = (function() {
      var mergeObjs;

      function LocalModel(options) {
        var _ref, _ref1, _ref2;
        if (options == null) {
          options = {};
        }
        this.fetchUrl = (_ref = options.fetchUrl) != null ? _ref : options.url;
        this.saveUrl = (_ref1 = options.saveUrl) != null ? _ref1 : options.url;
        this.$el = this.jQel = (_ref2 = options.$el) != null ? _ref2 : $(options.el);
        this.model = {};
      }

      LocalModel.prototype.render = function() {
        this.$el.html(this.model.value);
        return this;
      };

      LocalModel.prototype.fetch = function(data) {
        if (data == null) {
          data = {};
        }
        $.getJSON(this.fetchUrl, data, (function(_this) {
          return function(response) {
            _this.model = response;
            return _this.render();
          };
        })(this));
        return this;
      };

      LocalModel.prototype.save = function(model, extraData) {
        var data;
        if (model == null) {
          model = {};
        }
        if (extraData == null) {
          extraData = {};
        }
        data = mergeObjs(this.model, model, extraData);
        data = {
          model: JSON.stringify(data)
        };
        $.post(this.saveUrl, data, (function(_this) {
          return function(response) {
            model = response.model != null ? response.model : model;
            return _this.set(model);
          };
        })(this));
        return this;
      };

      LocalModel.prototype.set = function(model) {
        if (model == null) {
          model = {};
        }
        $.extend(this.model, model);
        this.render();
        return this.model;
      };

      LocalModel.prototype.get = function(key) {
        if (typeof key !== 'undefined') {
          return this.model[key];
        }
        return this.model;
      };

      mergeObjs = function() {
        var attr, newObj, obj, objs, val, _i, _len;
        objs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        newObj = {};
        for (_i = 0, _len = objs.length; _i < _len; _i++) {
          obj = objs[_i];
          for (attr in obj) {
            val = obj[attr];
            newObj[attr] = val;
          }
        }
        return newObj;
      };

      return LocalModel;

    })();
    LocalModel.extend = function(protoProps) {
      var Surrogate, child, parent;
      if (protoProps == null) {
        protoProps = {};
      }
      parent = this;
      child = function() {
        return parent.apply(this, arguments);
      };
      $.extend(child, parent);
      Surrogate = function() {
        this.constructor = child;
      };
      Surrogate.prototype = parent.prototype;
      child.prototype = new Surrogate;
      $.extend(child.prototype, protoProps);
      child.__super__ = parent.prototype;
      return child;
    };
    return LocalModel;
  };

  if (typeof define === "function" && typeof define.amd === "object" && define.amd) {
    define('LocalModel', ['jquery'], function($) {
      return localModel($);
    });
  } else {
    window.LocalModel = localModel($);
  }

}).call(this);
