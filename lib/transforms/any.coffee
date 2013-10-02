any = Enumerology.Transform.extend Enumerology.ReduceMixin,
  trueCount:    0
  value:        Em.computed.gt('trueCount', 0)
  initialValue: false

  addedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    @incrementProperty('trueCount') if callback.call(context.binding, item)
    @get('value')

  removedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    @decrementProperty('trueCount') if callback.call(context.binding, item)
    @get('value')

Enumerology.Transform.Any = any
