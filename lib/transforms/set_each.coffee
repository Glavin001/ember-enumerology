setEach = Enumerology.FilterBy.extend
  apply: (target, collection)->
    collection.setEach(@get('key'), @get('value'))
    collection

Enumerology.Transform.SetEach = setEach
