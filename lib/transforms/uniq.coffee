uniq = Enumerology.Filter.extend
  apply: (target, collection)->
    collection.uniq(@get('value'))

Enumerology.Transform.Uniq = uniq
