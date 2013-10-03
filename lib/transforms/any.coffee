any = Enumerology.Reduce.extend
  initialValue: false

  addedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    @incrementProperty('matchCount') if callback.call(context.binding, item)

  removedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    @decrementProperty('matchCount') if callback.call(context.binding, item)

Enumerology.Transform.Any = any
