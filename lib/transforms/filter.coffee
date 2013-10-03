filter = Enumerology.Filter.extend
  addedItem: (array, item, context)->
    callback = @get('callback')
    match = !!callback.call(context.binding, item)
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt filterIndex, item if match
    array

  removedItem: (array, item, context)->
    filterIndex = @get('subArray').removeItem(context.index)

    array.removeAt filterIndex if (filterIndex > -1) && array.get('length') > filterIndex
    array

Enumerology.Transform.Filter = filter
