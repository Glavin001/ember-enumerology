sortBy = Enumerology.FilterBy.extend
  init: ->
    @_super()
    @set('positionStore', {})

  addedItem: (array, item, context)->

    compareFunction = @get('compareFunction')
    key             = @get('key')
    doCompare       = (itemA,itemB)->
      compareFunction.call(context.binding, itemA, itemB)

    positionStore = @get('positionStore')

    if array.get('length') == 0
      positionStore[context.index] = 0
      array.insertAt(0, item)
      return array

    else
      for i in [0..array.get('length')-1]
        c = doCompare(item.get(key), array.objectAt(i).get(key))

        if c == -1
          positionStore[context.index] = i
          array.insertAt(i, item)
          return array

        if c == 0
          positionStore[context.index] = i + 1
          array.insertAt(i + 1, item)
          return array

      positionStore[context.index] = array.get('length')
      array.insertAt(array.get('length'), item)

  removedItem: (array, item, context)->
    positionStore = @get('positionStore')

    array.removeAt(positionStore[context.index])
    delete positionStore[context.index]

    array

Enumerology.Transform.SortBy = sortBy
