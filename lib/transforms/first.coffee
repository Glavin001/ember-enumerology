first = Enumerology.Reduce.extend
  initialValue: -> undefined
  returnValue: undefined

  addedItem: (accumulatedValue, item, context)->
    @set('returnValue', context.arrayChanged.get('firstObject'))

  removedItem: (accumulatedValue, item, context)->
    @set('returnValue', context.arrayChanged.get('firstObject'))

Enumerology.Transform.First = first
