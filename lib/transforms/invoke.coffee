invoke = Enumerology.Filter.extend
  addedItem: (array, item, context)->
    methodName = @get('methodName')
    args       = @getWithDefault('args', [])

    method = item.get(methodName)
    method.apply(item, args)

    array.insertAt(context.index, item)

    array

  removedItem: (array, item, context)->
    array.removeAt(context.index)

    array

Enumerology.Transform.Invoke = invoke
