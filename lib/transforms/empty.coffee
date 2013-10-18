empty = Enumerology.Reduce.extend
  initialValue: true
  matchCount:   0

  addedItem:   (accumulatedValue, item, context)->
    @incrementProperty('matchCount')
    @get('matchCount') == 0

  removedItem: (accumulatedValue, item, context)->
    @decrementProperty('matchCount')
    @get('matchCount') == 0

Enumerology.Transform.Empty = empty
