first = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.get('firstObject')

Enumerology.Transform.First = first
