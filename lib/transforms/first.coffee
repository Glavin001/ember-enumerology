first = Enumerology.Reduce.extend
  initialValue: -> undefined

  init: ->
    @set('content', Em.A())

  addedItem: (accumulatedValue, item, context)->
    content = @get('content')
    content.insertAt(context.index, item)
    content.get('firstObject')

  removedItem: (accumulatedValue, item, context)->
    content = @get('content')
    content.removeAt(context.index)
    content.get('firstObject')

Enumerology.Transform.First = first
