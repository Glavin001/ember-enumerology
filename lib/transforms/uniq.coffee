uniq = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.uniq(@get('value'))

Enumerology.Transform.Uniq = uniq
