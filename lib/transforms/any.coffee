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

Enumerology.Transform.Any = any
