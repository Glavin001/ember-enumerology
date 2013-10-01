map = Enumerology.Transform.extend Enumerology.FilterMixin,
  addedItem:   (array, item, context)->
    callback    = @get('callback')
    mappedValue = callback.call(context.binding, item)
    array.insertAt context.index, mappedValue
    array

  removedItem: (array, item, context)->
    array.removeAt context.index
    array

Enumerology.Transform.Map = map
