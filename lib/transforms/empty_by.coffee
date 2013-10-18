emptyBy = Enumerology.ReduceBy.extend
  initialValue: true
  matchCount:   0

  addedItem:   (accumulatedValue, item, context)->
    key = @get('key')
    @incrementProperty('matchCount') if item.get(key)?
    @get('matchCount') == 0

  removedItem: (accumulatedValue, item, context)->
    key = @get('key')
    @decrementProperty('matchCount') if item.get(key)?
    @get('matchCount') == 0

Enumerology.Transform.EmptyBy = emptyBy
