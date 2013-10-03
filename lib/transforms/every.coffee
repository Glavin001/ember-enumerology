every = Enumerology.Reduce.extend
  initialValue:  true
  totalElements: 0
  returnValue:   (->
    @get('matchCount') == @get('totalElements')
  ).property('matchCount', 'totalElements')

  addedItem:   (accumulatedValue, item, context)->
    callback = @get('callback')
    match    = !!callback.call(context.binding, item)
    @incrementProperty('totalElements')
    @incrementProperty('matchCount') if match

  removedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    match    = !!callback.call(context.binding, item)
    @decrementProperty('totalElements')
    @decrementProperty('matchCount') if match

Enumerology.Transform.Every = every
