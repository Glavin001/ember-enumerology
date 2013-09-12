emptyBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.mapBy(@get('key')).compact().get('length') == 0

Enumerology.Transform.EmptyBy = emptyBy
