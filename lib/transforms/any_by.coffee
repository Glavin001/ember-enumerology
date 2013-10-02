anyBy = Enumerology.TransformBy.extend Enumerology.ReduceMixin,
  trueCount:    0
  returnValue:  Em.computed.gt('trueCount', 0)
  initialValue: false

  addedItem:  (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    @incrementProperty('trueCount') if item.get(key) == value
    @get('returnValue')

  removedItem: (accumulatedValue, item, context)->
    key   = @get('key')
    value = @get('value')
    @decrementProperty('trueCount') if item.get(key) == value
    @get('returnValue')

Enumerology.Transform.AnyBy = anyBy
