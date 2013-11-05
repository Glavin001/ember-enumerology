isEvery = Enumerology.ReduceBy.extend
  initialValue:  true
  matchCount:    0
  totalElements: 0

  addedItem:   (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    match = item.get(key) == value
    @incrementProperty('totalElements')
    @incrementProperty('matchCount') if match
    @get('matchCount') == @get('totalElements')

  removedItem: (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    match = item.get(key) == value
    @decrementProperty('totalElements')
    @decrementProperty('matchCount') if match
    @get('matchCount') == @get('totalElements')

Enumerology.Transform.IsEvery = isEvery
