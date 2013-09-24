filter = Enumerology.Transform.extend
  subArray: undefined
  initialValue: undefined

  init: ->
    @set('subArray', new Ember.SubArray())
    @set('initialValue', Ember.A())

  addedItem: (array, item, context) ->
    callback = @get('callback')
    match = !!callback.call(context.binding, item)
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt filterIndex, item if match
    array

  removedItem: (array, item, context) ->
    filterIndex = @get('subArray').removeItem(context.index)
    array.removeAt(filterIndex) if filterIndex > -1
    array

Enumerology.Transform.Filter = filter
