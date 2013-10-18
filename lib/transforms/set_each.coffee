setEach = Enumerology.FilterBy.extend

  addedItem: (array, item, context)->
    key   = @get('key')
    value = @get('value')

    item.set(key, value)

    array.insertAt(context.index, item)
    array

  removedItem: (array, item, context)->
    array.removeAt(context.index)
    array

Enumerology.Transform.SetEach = setEach
