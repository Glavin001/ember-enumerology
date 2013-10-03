empty = Enumerology.Reduce.extend
  initialValue: true
  returnValue:  Em.computed.equal('matchCount', 0)

  addedItem: (accumulatedValue, item, context)->
    @incrementProperty('matchCount')

  removedItem: (accumulatedValue, item, context)->
    @decrementProperty('matchCount')

Enumerology.Transform.Empty = empty
