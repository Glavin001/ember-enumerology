filter = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.filter(@get('callback'), @getWithDefault('target', target))

Enumerology.Transform.Filter = filter
