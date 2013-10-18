last = Enumerology.Reduce.extend
  initialValue: -> undefined

  init: ->
    @set('content', Em.A())

  addedItem: (accumulatedValue, item, context)->
    content = @get('content')
    content.insertAt(context.index, item)
    content.get('lastObject')

  removedItem: (accumulatedValue, item, context)->
    content = @get('content')
    content.removeAt(context.index)
    content.get('lastObject')

Enumerology.Transform.Last = last
