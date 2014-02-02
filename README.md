jquery-localmodel
=================

[![Build Status](https://travis-ci.org/simock85/jquery-localmodel.png?branch=master)](https://travis-ci.org/simock85/jquery-localmodel)

jquery-localmodel simplifies asynchronous communication and dom manipulation in your *old but solid gold* server-side
web application.

It handles the dirty work of storing data on the client side, and keeping that data in sync with your server and
the UI.

Reference
----------

For the complete documentation, see the annotated source at
http://simock85.github.io/jquery-localmodel/jquery-localmodel.html

How-To for people in a hurry
-----------------------------

**Add the script to your page**

```html
<script src="path/to/jquery-localmodel.min.js"></script>
```

**Create a new LocalModel object**

```javascript
var myModel = new LocalModel({
    fetchUrl: 'path/to/get/endpoint',
    saveUrl: 'path/to/post/endpoint',
    el: '#my-model-node'
});
```

**Fetch the model from the server**

```javascript
myModel.fetch();
```
The model is fetched from `fetchUrl` and stored in the localModel. If the model contains a `value` attribute,
`model.value` will be set as content of the node(s) matched by `el`. The drawing is performed by `myModel.render()`
that, of course, can be manually called to perform a redraw.

**Get model values**

You can get a single attribute of the model with `myModel.get(attribute)` or the entire model with `myModel.get()`

**Update the model**

```javascript
myModel.save({spam: 'egg'});
```
The first argument of `save` is merged into the localModel (the merge is performed using `jQuery.extend`).
localModel is POSTed to `saveUrl`. localModel is JSON serialized under a model parameter, and the request is made
with a `application/x-www-form-urlencoded` MIME type. If the server response contains `model` key,
`model` will be merged into localModel. After that the UI will be updated by calling `myModel.render()`.

It's also possible to update the model without issuing the POST to the server, using `myModel.set({spam: 'egg'})` or
directly accessing the underlying object `myModel.model`. If the update is performed using `set`, `myModel.render()`
is then called.