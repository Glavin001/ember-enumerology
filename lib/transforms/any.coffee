any = Enumerology.Reduce.extend
  initialValue: false
  matchCount:   0

  addedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    @incrementProperty('matchCount') if callback.call(context.binding, item)
    @get('matchCount') > 0

  removedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    @decrementProperty('matchCount') if callback.call(context.binding, item)
    @get('matchCount') > 0

Enumerology.Transform.Any = any
