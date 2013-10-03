mapBy = Enumerology.FilterBy.extend
  addedItem: (array, item, context)->
    key = @get('key')
    array.insertAt context.index, item.get(key)
    array

  removedItem: (array, item, context)->
    array.removeAt context.index
    array

Enumerology.Transform.MapBy = mapBy
