find = Enumerology.Reduce.extend
  initialValue: -> undefined

  init: ->
    @set('matches', Em.A())
    @set('subArray', new Em.SubArray())
    @_super()

  addedItem: (accumulatedValue, item, context)->
    callback    = @get('callback')
    match       = callback.call(context.binding, item)
    subArray    = @get('subArray')
    filterIndex = subArray.addItem(context.index, match)
    matches     = @get('matches')
    matches.insertAt filterIndex, item if match
    matches.get('firstObject')

  removedItem: (accumulatedValue, item, context)->
    callback = @get('callback')
    match    = callback.call(context.binding, item)
    subArray = @get('subArray')
    filterIndex = subArray.removeItem(context.index)
    matches     = @get('matches')
    matches.removeAt filterIndex if (filterIndex > -1) && matches.get('length') > filterIndex
    matches.get('firstObject')

Enumerology.Transform.Find = find
