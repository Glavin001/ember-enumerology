emptyBy = Enumerology.ReduceBy.extend
  initialValue: true
  returnValue:  Em.computed.equal('matchCount', 0)

  addedItem: (accumulatedValue, item, context)->
    key = @get('key')
    @incrementProperty('matchCount') if item.get(key)?

  removedItem: (accumulatedValue, item, context)->
    key = @get('key')
    @decrementProperty('matchCount') if item.get(key)?

Enumerology.Transform.EmptyBy = emptyBy
