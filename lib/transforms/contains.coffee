contains = Enumerology.Reduce.extend
  initialValue: false

  addedItem:   (accumulatedValue, item, context)->
    @incrementProperty('matchCount') if item == @get('obj')

  removedItem: (accumulatedValue, item, context)->
    @decrementProperty('matchCount') if item == @get('obj')

Enumerology.Transform.Contains = contains
