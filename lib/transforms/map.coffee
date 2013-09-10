map = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.map(@get('callback'), @getWithDefault('target', target))

Enumerology.Transform.Map = map
