filterBy = Enumerology.FilterBy.extend
  addedItem: (array, item, context)->
    key   = @get('key')
    value = @get('value')
    match = item.get(key) == value
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt filterIndex, item if match
    array

  removedItem: (array, item, context)->
    key   = @get('key')
    value = @get('value')
    match = item.get(key) == value
    filterIndex = @get('subArray').removeItem(context.index)

    array.removeAt filterIndex if (filterIndex > -1) && array.get('length') > filterIndex
    array

Enumerology.Transform.FilterBy = filterBy
