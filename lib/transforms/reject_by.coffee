rejectBy = Enumerology.FilterBy.extend
  apply: (target, collection)->
    collection.rejectBy(@get('key'), @get('value'))

Enumerology.Transform.RejectBy = rejectBy
