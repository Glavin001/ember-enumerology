compactBy = Enumerology.FilterBy.extend
  addedItem: (array, item, context)->
    key   = @get('key')
    match = item.get(key)?
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt filterIndex, item if match
    array

  removedItem: (array, item, context)->
    key   = @get('key')
    match = item.get(key)?
    filterIndex = @get('subArray').removeItem(context.index, match)

    array.removeAt filterIndex if filterIndex > -1
    array

Enumerology.Transform.CompactBy = compactBy
