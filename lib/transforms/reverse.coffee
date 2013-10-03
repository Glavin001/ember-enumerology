reverse = Enumerology.Filter.extend
  apply: (target, collection)->
    collection.slice(0).reverse()

Enumerology.Transform.Reverse = reverse
