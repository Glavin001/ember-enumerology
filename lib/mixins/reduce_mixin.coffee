Enumerology.ReduceMixin = Em.Mixin.create
  initialValue: undefined
  returnValue:  Em.computed.gt('matchCount', 0)
  isReduce:     true
  isFilter:     false
  matchCount:   0

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
        @get('returnValue')

      removedItem:  (accumulator, item, changeMeta, instanceMeta)=>
        @removedItem.call(@, accumulator, item, changeMeta)
        @get('returnValue')
