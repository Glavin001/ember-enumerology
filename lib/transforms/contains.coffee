contains = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.contains(@get('obj'))

Enumerology.Transform.Contains = contains
