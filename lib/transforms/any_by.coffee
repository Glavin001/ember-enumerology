anyBy = Enumerology.ReduceBy.extend
  initialValue: false

  addedItem:  (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    @incrementProperty('matchCount') if item.get(key) == value

  removedItem: (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    @decrementProperty('matchCount') if item.get(key) == value

Enumerology.Transform.AnyBy = anyBy
