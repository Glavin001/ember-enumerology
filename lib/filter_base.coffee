Enumerology.FilterBase = Em.Object.extend
  initialValue: undefined
  subArray: undefined

  init: ->
    @set('initialValue', Em.A())
    @set('subArray', new Ember.SubArray())
    @_super()

  apply: (dependentKey,target)->
    dependency   = "#{dependentKey}#{@get('dependencies')}"
    @set('dependentKey', dependentKey)

    Em.arrayComputed dependency,
      initialValue: @get('initialValue')

      initialize:   (initialValue, changeMeta, instanceMeta)->
        changeMeta.binding = target
        @reset.call(@, initialValue, changeMeta, instanceMeta) unless Em.isEmpty(@reset)

      addedItem:    (accumulator, item, changeMeta, instanceMeta)=>
        @addedItem.call(@, accumulator, item, changeMeta)

      removedItem:  (accumulator, item, changeMeta, instanceMeta)=>
        @removedItem.call(@, accumulator, item, changeMeta)

  # This particular removed item is pretty common, so we'll stick it here.
  removedItem: (array, item, context)->
    filterIndex = @get('subArray').removeItem(context.index)

    array.removeAt filterIndex if (filterIndex > -1) && array.get('length') > filterIndex
    array

Enumerology.FilterBase.reopenClass
  isReduce: false
  isFilter: Em.computed.not('isReduce')
