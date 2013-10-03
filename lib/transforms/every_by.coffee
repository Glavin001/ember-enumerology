everyBy = Enumerology.ReduceBy.extend
  initialValue:  true
  totalElements: 0
  returnValue:   (->
    @get('matchCount') == @get('totalElements')
  ).property('matchCount', 'totalElements')

  addedItem:   (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    match = item.get(key) == value
    @incrementProperty('totalElements')
    @incrementProperty('matchCount') if match

  removedItem: (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    match = item.get(key) == value
    @decrementProperty('totalElements')
    @decrementProperty('matchCount') if match

Enumerology.Transform.EveryBy = everyBy
