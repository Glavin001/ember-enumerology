filter = Enumerology.Transform.extend Enumerology.FilterMixin,
  subArray: undefined

  init: ->
    @set('subArray', new Ember.SubArray())
    @_super()

  addedItem: (array, item, context) ->
    callback = @get('callback')
    match = !!callback.call(context.binding, item)
    filterIndex = @get('subArray').addItem(context.index, match)

    array.insertAt filterIndex, item if match
    array

  removedItem: (array, item, context) ->
    console.log "#{@get('targetKey')} removedItem: ", array, item, context
    filterIndex = @get('subArray').removeItem(context.index)

    console.log "Removing at #{filterIndex}"
    console.log "modifying array: ", array
    array.removeAt filterIndex if filterIndex > -1
    console.log "resulting array: ", array
    array

Enumerology.Transform.Filter = filter
