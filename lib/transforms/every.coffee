every = Enumerology.Reduce.extend
  initialValue:  true
  matchCount:    0
  totalElements: 0

  reset:       ->
    @set('matchCount', 0)

  addedItem:   (accumulatedValue, item, context)->
    callback = @get('callback')
    match    = !!callback.call(context.binding, item)
    @incrementProperty('totalElements')
    @incrementProperty('matchCount') if match
    @get('matchCount') == @get('totalElements')

  removedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    match    = !!callback.call(context.binding, item)
    @decrementProperty('totalElements')
    @decrementProperty('matchCount') if match
    @get('matchCount') == @get('totalElements')

Enumerology.Transform.Every = every
