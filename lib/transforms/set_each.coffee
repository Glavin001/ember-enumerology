setEach = Enumerology.FilterBy.extend

  addedItem: (array, item, context)->
    key   = @get('key')
    value = @get('value')

    item.set(key, value)

    context.arrayChanged

  removedItem: (array, item, context)->
    context.arrayChanged

Enumerology.Transform.SetEach = setEach
