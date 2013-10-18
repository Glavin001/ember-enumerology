length = Enumerology.Reduce.extend
  initialValue: 0

  addedItem: (accumulatedValue, item, context)->
    ++accumulatedValue

  removedItem: (accumulatedValue, item, context)->
    --accumulatedValue

Enumerology.Transform.Length = length
