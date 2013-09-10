every = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.every(@get('callback'), @getWithDefault('target', target))

Enumerology.Transform.Every = every
