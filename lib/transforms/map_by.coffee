mapBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.mapBy(@get('key'))

Enumerology.Transform.MapBy = mapBy
