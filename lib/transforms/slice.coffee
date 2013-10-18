slice = Enumerology.Filter.extend

  # Array's can be sliced correctly when the begining and
  # end are positive integer values, however when they're
  # negatives we can't do it, because we don't know the
  # final length of the array.  We have to rely on
  # resetting behaviour.

  addedItem: (array, item, context)->
    context.arrayChanged.slice(@get('begin'), @get('end'))

  removedItem: (array, item, context)->
    context.arrayChanged.slice(@get('begin'), @get('end'))

Enumerology.Transform.Slice = slice
