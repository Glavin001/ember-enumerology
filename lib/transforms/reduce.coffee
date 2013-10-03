reduce = Enumerology.Reduce.extend
  apply: (target, collection)->
    collection.reduce(@get('callback'), @get('initialValue'))

Enumerology.Transform.Reduce = reduce
