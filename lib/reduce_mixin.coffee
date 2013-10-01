Enumerology.ReduceMixin = Em.Mixin.create
  initialValue: undefined
  isReduce: true
  isFilter: false

  apply: (dependentKey,target)->
    dependency   = "#{dependentKey}#{@get('dependencies')}"
    initialValue = @get('initialValue')
    @set('targetKey', dependentKey)

    Em.reduceComputed dependency,
      initialValue: initialValue,
      initialize:   (initialValue, changeMeta, instanceMeta)->
        changeMeta.binding = target

      addedItem:    (accumulator, item, changeMeta, instanceMeta)=>
        @addedItem.call(@, accumulator, item, changeMeta)

      removedItem:  (accumulator, item, changeMeta, instanceMeta)=>
        @removedItem.call(@, accumulator, item, changeMeta)
