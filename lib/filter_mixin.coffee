Enumerology.FilterMixin = Em.Mixin.create
  initialValue: undefined
  isReduce: false
  isFilter: true

  init: ->
    @set('initialValue', Em.A())
    @_super()

  apply: (dependentKey,target)->
    dependency   = "#{dependentKey}#{@get('dependencies')}"
    initialValue = @get('initialValue')
    @set('targetKey', dependentKey)

    Em.arrayComputed dependency,
      initialValue: initialValue
      initialize: (initialValue, changeMeta, instanceMeta)->
        changeMeta.binding = target

      addedItem: (accumulator, item, changeMeta, instanceMeta)=>
        @addedItem.call(@, accumulator, item, changeMeta)

      removedItem: (accumulator, item, changeMeta, instanceMeta)=>
        @removedItem.call(@, accumulator, item, changeMeta)

