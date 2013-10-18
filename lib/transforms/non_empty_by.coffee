nonEmptyBy = Enumerology.ReduceBy.extend
  initialValue: false
  count:        0

  addedItem:   (accumulatedValue, item, context)->
    @incrementProperty('count') unless Em.isEmpty(item.get(@get('key')))
    @get('count') > 0

  removedItem: (accumulatedValue, item, context)->
    @decrementProperty('count') unless Em.isEmpty(item.get(@get('key')))
    @get('count') > 0

Enumerology.Transform.NonEmptyBy = nonEmptyBy
