sort = Enumerology.Transform.extend
  apply: (target, collection)->
    compareFunction = @get('compareFunction')
    if Em.isEmpty(compareFunction)
      collection.slice(0).sort()
    else
      collection.slice(0).sort(@get('compareFunction'))

Enumerology.Transform.Sort = sort
