classify = (name)->
  name.charAt(0).toUpperCase() + name.slice(1)

# assert = Ember.assert || (msg,test)->
assert = (msg,test) ->
  throw new Error(msg) unless test

lexigraphicCompare = (a,b)-> compare(a.toString(), b.toString())
numericCompare = (a,b)-> compare(Number(a), Number(b))

compare = (a,b)->
  if a > b
    1
  else if a < b
    -1
  else
    0

addTransformation = (name, opts={})->
  newTransform = Enumerology.Transform[classify(name)].create(opts)
  newTransform.set('pipeline', @)

  if @get("transformations.length") > 0
    assert "Cannot add any further operations after a reduce operation", @get('transformations.lastObject.isFilter')

  @get('transformations').addObject(newTransform)
  @

pipeline = Em.Object.extend
  init: ->
    @_super()
    @['getEach']     = @['mapBy']
    @['mapProperty'] = @['mapBy']
    @['isEmpty']     = @['empty']
    @['isEmptyBy']   = @['emptyBy']
    @['size']        = @['length']
    @['tee']         = @['invoke']
    @set('transformations', Em.A())

  finalize: ->
    baseKey         = @get('dependentKey')
    assert "Must have a dependent key", !Em.isEmpty(baseKey)

    transformations = @get('transformations')
    assert "Must have at least one transformation applied", transformations.get('length') > 0

    lastTransformation = transformations.get('lastObject')

    dependentKeys   = transformations.map((item)->
      dependencies = item.get('dependencies')
      "#{baseKey}#{dependencies}" unless Em.isEmpty(dependencies)
    ).compact().uniq()

    initialValue = lastTransformation.get('initialValue')
    initialValue = initialValue() if typeof initialValue == 'function'

    Em.computed dependentKeys..., ->
      key    = "_target.#{baseKey}"
      target = @
      metaProperties = Em.Object.create()
      metaProperties.set('_target', target)

      transformations.forEach (transform, i)->
        computed = transform.apply(key, target)
        key      = "_transform_#{i}_result"
        Em.defineProperty(metaProperties, key, computed)

      metaProperties.getWithDefault(key, initialValue)

  any: (callback)->
    addTransformation.call(@, 'any', {callback: callback})

  anyBy: (key,value=null)->
    addTransformation.call(@, 'anyBy', {key: key, value: value})

  compact: ->
    addTransformation.call(@, 'compact', {})

  compactBy: (key)->
    addTransformation.call(@, 'compactBy', {key: key})

  contains: (obj)->
    addTransformation.call(@, 'contains', {obj: obj})

  empty: ->
    addTransformation.call(@, 'empty')

  emptyBy: (key)->
    addTransformation.call(@, 'emptyBy', {key: key})

  every: (callback, target=null)->
    addTransformation.call(@, 'every', {callback: callback, target: target})

  everyBy: (key, value=null)->
    addTransformation.call(@, 'everyBy', {key: key, value: value})

  filter: (callback, target=null)->
    addTransformation.call(@, 'filter', {callback: callback, target: target})

  filterBy: (key, value=null)->
    addTransformation.call(@, 'filterBy', {key: key, value: value})

  find: (callback, target=null)->
    addTransformation.call(@, 'find', {callback: callback, target: target})

  findBy: (key, value=null)->
    addTransformation.call(@, 'findBy', {key: key, value: value})

  first: ->
    addTransformation.call(@, 'first')

  invoke: (methodName, args...)->
    addTransformation.call(@, 'invoke', {methodName: methodName, args: args})

  join: (separator=undefined)->
    addTransformation.call(@, 'join', {separator: separator})

  last: ->
    addTransformation.call(@, 'last')

  length: ->
    addTransformation.call(@, 'length')

  map: (callback, target=null)->
    addTransformation.call(@, 'map', {callback: callback, target: target})

  mapBy: (key)->
    addTransformation.call(@, 'mapBy', {key: key})

  nonEmpty: ->
    addTransformation.call(@, 'nonEmpty')

  nonEmptyBy: (key)->
    addTransformation.call(@, 'nonEmptyBy', {key: key})

  reduce: (callback, initialValue)->
    addTransformation.call(@, 'reduce', {callback: callback, initialValue: initialValue})

  reject: (callback, target=null)->
    addTransformation.call(@, 'reject', {callback: callback, target: target})

  rejectBy: (key, value=null)->
    addTransformation.call(@, 'rejectBy', {key: key, value: value})

  reverse: ->
    addTransformation.call(@, 'reverse')

  setEach: (key, value)->
    addTransformation.call(@, 'setEach', {key: key, value: value})

  slice: (begin,end=null)->
    addTransformation.call(@, 'slice', {begin: begin, end: end})

  sort: (compareFunction=undefined)->
    addTransformation.call(@, 'sort', {compareFunction: compareFunction})

  sortBy: (key,compareFunction=undefined)->
    compareFunction = lexigraphicCompare if Em.isEmpty(compareFunction)
    addTransformation.call(@, 'sortBy', {key: key, compareFunction: compareFunction})

  sortNumerically: ->
    addTransformation.call(@, 'sort', {compareFunction: numericCompare})

  sortNumericallyBy: (key)->
    addTransformation.call(@, 'sortBy', {key: key, compareFunction: numericCompare})

  take: (howMany)->
    addTransformation.call(@, 'take', {howMany: howMany})

  toSentence: (conjunction='and', oxfordComma=false)->
    addTransformation.call(@, 'toSentence', {conjunction: conjunction, oxfordComma: oxfordComma})

  uniq: ->
    addTransformation.call(@, 'uniq')

  without: (value)->
    addTransformation.call(@, 'without', {value: value})

Enumerology.Pipeline = pipeline
