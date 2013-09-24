any = Enumerology.Transform.extend
  trueCount: 0
  value: Ember.computed.gt('trueCount', 0)

  initialValue: false

  addedItem: (accumulatedValue, item, context) ->
    callback = @get('callback')
    @incrementProperty('trueCount') if callback.call(context.binding, item)
    return @get('value')

  removedItem: (accumulatedValue, item, context) ->
    callback = @get('callback')
    @decrementProperty('trueCount') if callback.call(context.binding, item)
    return @get('value')

  # apply: (target, collection)->
  #   collection.any(@get('callback'), @getWithDefault('target', target))

Enumerology.Transform.Any = any
