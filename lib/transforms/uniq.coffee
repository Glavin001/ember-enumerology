uniq = Enumerology.Filter.extend
  addedItem: (array, item, context)->
    match       = (array.get('length') == 0) || !(array.any((i)-> i == item))
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt(filterIndex, item) if filterIndex >= 0
    array

  removedItem: (array, item, context)->
    filterIndex = @get('subArray').removeItem(context.index)
    array.removeAt(filterIndex) if filterIndex >= 0
    array

Enumerology.Transform.Uniq = uniq
