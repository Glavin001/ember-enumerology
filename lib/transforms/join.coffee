join = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.join(@get('separator'))

Enumerology.Transform.Join = join
