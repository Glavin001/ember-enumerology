compact = Enumerology.Filter.extend
  addedItem: (array, item, context)->
    match = item?
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt filterIndex, item if match
    array

  removedItem: (array, item, context)->
    match = item?
    filterIndex = @get('subArray').removeItem(context.index, match)

    array.removeAt filterIndex if filterIndex > -1
    array

Enumerology.Transform.Compact = compact
