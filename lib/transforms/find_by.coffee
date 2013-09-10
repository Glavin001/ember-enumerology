findBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    collection.findBy(@get('key'), @get('value'))

Enumerology.Transform.FindBy = findBy
