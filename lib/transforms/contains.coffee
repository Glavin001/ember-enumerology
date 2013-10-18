contains = Enumerology.Reduce.extend
  initialValue: false
  matchCount:   0

  addedItem:   (accumulatedValue, item, context)->
    @incrementProperty('matchCount') if item == @get('obj')
    @get('matchCount') > 0

  removedItem: (accumulatedValue, item, context)->
    @decrementProperty('matchCount') if item == @get('obj')
    @get('matchCount') > 0

Enumerology.Transform.Contains = contains
