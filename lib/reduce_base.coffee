Enumerology.ReduceBase = Em.Object.extend
  initialValue: undefined
  matchCount:   0

  apply: (dependentKey,target)->
    @set('dependentKey', dependentKey)

    Em.reduceComputed dependentKey,
      initialValue: @get('initialValue'),

      initialize:   (initialValue, changeMeta, instanceMeta)=>
        changeMeta.binding = target
        @reset.call(@, initialValue, changeMeta, instanceMeta) unless Em.isEmpty(@reset)

      addedItem:    (accumulator, item, changeMeta, instanceMeta)=>
        @addedItem.call(@, accumulator, item, changeMeta) unless Em.isEmpty(@addedItem)

      removedItem:  (accumulator, item, changeMeta, instanceMeta)=>
        @removedItem.call(@, accumulator, item, changeMeta) unless Em.isEmpty(@removedItem)

Enumerology.ReduceBase.reopenClass
  isReduce:     true
  isFilter:     Em.computed.not('isReduce')
