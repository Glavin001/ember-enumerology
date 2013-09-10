anyBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.anyBy(@get('key'), @get('value'))

Enumerology.Transform.AnyBy = anyBy
