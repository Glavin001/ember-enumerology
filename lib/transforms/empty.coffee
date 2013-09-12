empty = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.get('length') == 0

Enumerology.Transform.Empty = empty
