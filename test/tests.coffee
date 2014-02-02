module 'test ajax',
  setup: ()->
    @jQget = $.get
    @jQpost = $.post
    $.get = $.post = (url, data, success)->
      if data.model? and typeof data.model is 'string'
        data.model = JSON.parse(data.model)
      success(data)

  teardown: ()->
    $.get = @jQget
    $.post = @jQpost

test 'fetch model', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.fetch spam: 'egg'
  deepEqual model.model, spam: 'egg'

test 'merge and save model', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.save spam: 'egg'
  deepEqual model.model, spam: 'egg'

test 'save model and merge response', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.save {}, spam: 'egg'
  deepEqual model.model, spam: 'egg'

test 'correctly merge response', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.save spam: 'ham', spam: 'egg'
  deepEqual model.model, spam: 'egg'

module 'test ui'
test 'test render', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.model.value = 'foo'
  model.render()
  equal $('#qunit-fixture').html(), 'foo'

module 'test model'
test 'get value', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.model = spam: 'egg', foo: 'bar'
  equal model.get('spam'), 'egg'

test 'get entire model', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.model = spam: 'egg', foo: 'bar'
  deepEqual model.get(), spam: 'egg', foo: 'bar'

test 'set value', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.model = spam: 'egg', foo: 'bar'
  model.set(spam: 'ham')
  equal model.get('spam'), 'ham'

test 'set multiple values', ()->
  model = new LocalModel({url: 'foo', el: '#qunit-fixture'})
  model.model = spam: 'egg', foo: 'bar'
  model.set(spam: 'ham', foo: 'egg')
  equal model.get('spam'), 'ham'
  equal model.get('foo'), 'egg'

module 'test inheritance'
test 'test override proto method', ()->
  MyModel = LocalModel.extend(fetch: ()->
    return 'ok'
  )
  model = new MyModel {url: 'foo', el: '#qunit-fixture'}
  equal(model.fetch(), 'ok')

test 'test __super__ alias', ()->
  expect 1
  MyModel = LocalModel.extend(fetch: ()->
    equal(MyModel.__super__.fetch, LocalModel.prototype.fetch)
  )
  model = new MyModel {url: 'foo', el: '#qunit-fixture'}
  model.fetch()
