reduce = Enumerology.Reduce.extend

  addedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    callback.call(context.binding, accumulatedValue, item, context.index, context.arrayChanged)

  # there is no removedItem because we rely on resetting behaviour.

Enumerology.Transform.Reduce = reduce
