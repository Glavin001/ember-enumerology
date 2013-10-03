join = Enumerology.Reduce.extend
  initialValue: ''

  addedItem: (accumulatedValue, item, context)->
    @set('returnValue', context.arrayChanged.join(@get('separator')))

  removedItem: (accumulatedValue, item, context)->
    @set('returnValue', context.arrayChanged.join(@get('separator')))

Enumerology.Transform.Join = join
