everyBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.everyBy(@get('key'), @get('value'))
Enumerology.Transform.EveryBy = everyBy
