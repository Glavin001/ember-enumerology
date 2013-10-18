nonEmpty = Enumerology.Reduce.extend
  initialValue: false
  count:        0

  addedItem: (accumulatedValue, item, context)->
    @incrementProperty('count')
    @get('count') > 0

  removedItem: (accumulatedValue, item, context)->
    @decrementProperty('count')
    @get('count') > 0

Enumerology.Transform.NonEmpty = nonEmpty
