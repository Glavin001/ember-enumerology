filterBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.filterBy(@get('key'), @get('value'))

Enumerology.Transform.FilterBy = filterBy
