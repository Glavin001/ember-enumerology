any = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.any(@get('callback'), @getWithDefault('target', target))

Enumerology.Transform.Any = any
