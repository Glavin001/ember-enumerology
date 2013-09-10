classify = (name)->
  name.charAt(0).toUpperCase() + name.slice(1)

# assert = Ember.assert || (msg,test)->
assert = (msg,test) ->
  throw new Error(msg) unless test

pipeline = Em.Object.extend
  init: ->
    @_super()
    @['getEach']     = @['mapBy']
    @['mapProperty'] = @['mapBy']
    @['size']        = @['length']
    @set('transformations', [])

  finalize: ->
    baseKey         = @get('dependentKey')
    assert "Must have a dependent key", !Em.isEmpty(baseKey)

    transformations = @get('transformations')
    assert "Must have at least one transformation applied", transformations.get('length') > 0

    dependentKeys   = transformations.map((item)-> "#{baseKey}#{item.get('dependencies')}").uniq()

    Ember.computed dependentKeys..., ->
      result = @get(baseKey)

      transformations.forEach (transform)->
        result = transform.apply(@,result)

      result

  any: (callback)->
    @_addTransformation('any', {callback: callback})

  anyBy: (key,value=null)->
    @_addTransformation('anyBy', {key: key, value: value})

  compact: ->
    @_addTransformation('compact', {})

  contains: (obj)->
    @_addTransformation('contains', {obj: obj})

  every: (callback, target=null)->
    @_addTransformation('every', {callback: callback, target: target})

  everyBy: (key, value=null)->
    @_addTransformation('everyBy', {key: key, value: value})

  filter: (callback, target=null)->
    @_addTransformation('filter', {callback: callback, target: target})

  filterBy: (key, value=null)->
    @_addTransformation('filterBy', {key: key, value: value})

  find: (callback, target=null)->
    @_addTransformation('find', {callback: callback, target: target})

  findBy: (key, value=null)->
    @_addTransformation('findBy', {key: key, value: value})

  invoke: (methodName, args...)->
    @_addTransformation('invoke', {methodName: methodName, args: args})

  length: ->
    @_addTransformation('length')

  map: (callback, target=null)->
    @_addTransformation('map', {callback: callback, target: target})

  mapBy: (key)->
    @_addTransformation('mapBy', {key: key})

  reduce: (callback, initialValue)->
    @_addTransformation('reduce', {callback: callback, initialValue: initialValue})

  reject: (callback, target=null)->
    @_addTransformation('reject', {callback: callback, target: target})

  rejectBy: (key, value=null)->
    @_addTransformation('rejectBy', {key: key, value: value})

  setEach: (key, value)->
    @_addTransformation('setEach', {key: key, value: value})

  uniq: ->
    @_addTransformation('uniq')

  without: (value)->
    @_addTransformation('without', {value: value})

  _addTransformation: (name, opts)->
    @get('transformations').addObject(Enumerology.Transform[classify(name)].create(opts))
    @

Enumerology.Pipeline = pipeline
