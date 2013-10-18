reverse = Enumerology.Filter.extend
  addedItem: (array, item, context)->
    newIndex = array.get('length') - context.index
    array.insertAt(newIndex, item)
    array

  removedItem: (array, item, context)->
    newIndex = array.get('length') - context.index
    array.removeAt(newIndex-1)
    array

Enumerology.Transform.Reverse = reverse
