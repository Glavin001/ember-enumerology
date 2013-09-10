reverse = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.slice(0).reverse()

Enumerology.Transform.Reverse = reverse
