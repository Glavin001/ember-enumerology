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
  opts['pipeline'] = @
  newTransform = Enumerology.Transform[classify(name)].extend(opts)

  if @get("transformations.length") > 0
    assert "Cannot add any further operations after a reduce operation", @get('transformations.lastObject.isFilter')

  @get('transformations').addObject(newTransform)
  @

uniquePipline = (meta, targetKey)->
  meta['__enumerology__'] = {} if Em.isEmpty(meta['__enumerology__'])
  meta['__enumerology__'][targetKey] = Em.Object.create() if Em.isEmpty(meta['__enumerology__'][targetKey])
  meta['__enumerology__'][targetKey]

pipeline = Em.Object.extend
  init: ->
    @_super()
    @['getEach']     = @['mapBy']
    @['mapProperty'] = @['mapBy']
    @['isEmpty']     = @['empty']
    @['isEmptyBy']   = @['emptyBy']
    @['size']        = @['length']
    @['tee']         = @['invoke']
    @['some']        = @['nonEmpty']
    @['someBy']      = @['nonEmptyBy']
    @set('transformations', Em.A())

  finalize: ->
    baseKey         = @get('dependentKey')
    assert "Must have a dependent key", !Em.isEmpty(baseKey)

    transformations = @get('transformations')
    assert "Must have at least one transformation applied", transformations.get('length') > 0

    firstDependentKey = "#{baseKey}#{transformations.get('firstObject').create().get('dependencies')}"

    Em.computed firstDependentKey, (targetKey)->
      target   = @
      meta     = Em.meta(target)
      pipeline = uniquePipline(meta, targetKey)

      if Em.isEmpty(pipeline.get('target'))
        pipeline.set('target',  target)
        pipeline.set('lastKey', "target.#{baseKey}")

        transformations.forEach (transformClass, i)->
          transform = transformClass.create()
          computed  = transform.apply(pipeline.get('lastKey'), target)

          pipeline.set("transform_#{i}", transform)
          pipeline.set("computed_#{i}",  computed)
          pipeline.set('lastKey',        "result_#{i}")

          Em.defineProperty(pipeline, pipeline.get('lastKey'), computed)

      pipeline.get(pipeline.get('lastKey'))

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

  skip: (count)->
    addTransformation.call(@, 'slice', {begin: count, end: undefined})

  slice: (begin,end=undefined)->
    addTransformation.call(@, 'slice', {begin: begin, end: end})

  sort: (compareFunction=lexigraphicCompare)->
    addTransformation.call(@, 'sort', {compareFunction: compareFunction})

  sortBy: (key,compareFunction=undefined)->
    compareFunction = lexigraphicCompare if Em.isEmpty(compareFunction)
    addTransformation.call(@, 'sortBy', {key: key, compareFunction: compareFunction})

  sortNumerically: ->
    addTransformation.call(@, 'sort', {compareFunction: numericCompare})

  sortNumericallyBy: (key)->
    addTransformation.call(@, 'sortBy', {key: key, compareFunction: numericCompare})

  take: (howMany)->
    addTransformation.call(@, 'slice', {begin: 0, end: howMany})

  toSentence: (conjunction='and', oxfordComma=false)->
    addTransformation.call(@, 'toSentence', {conjunction: conjunction, oxfordComma: oxfordComma})

  uniq: ->
    addTransformation.call(@, 'uniq')

  without: (value)->
    addTransformation.call(@, 'without', {value: value})

Enumerology.Pipeline = pipeline
