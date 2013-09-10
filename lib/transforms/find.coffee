find = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.find(@get('callback'), @getWithDefault('target', target))

Enumerology.Transform.Find = find
