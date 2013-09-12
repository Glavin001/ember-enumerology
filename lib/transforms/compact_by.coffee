compactBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.map((i) -> Em.isEmpty(i.get(@get('key')))).compact()

Enumerology.Transform.CompactBy = compactBy
