join = Enumerology.Reduce.extend
  initialValue: ''
  init: ->
    @set('content', Em.A())

  addedItem: (accumulatedValue, item, context)->
    content = @get('content')
    content.insertAt(context.index, item)
    content.join(@get('separator'))

  removedItem: (accumulatedValue, item, context)->
    content = @get('content')
    content.removeAt(context.index)
    content.join(@get('separator'))

Enumerology.Transform.Join = join
