anyBy = Enumerology.ReduceBy.extend
  initialValue: false
  matchCount:   0

  addedItem:  (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    @incrementProperty('matchCount') if item.get(key) == value
    @get('matchCount') > 0

  removedItem: (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    @decrementProperty('matchCount') if item.get(key) == value
    @get('matchCount') > 0

Enumerology.Transform.AnyBy = anyBy
