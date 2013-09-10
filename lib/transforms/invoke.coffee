invoke = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.invoke(@get('methodName'), @getWithDefault('args', [])...)

Enumerology.Transform.Invoke = invoke
