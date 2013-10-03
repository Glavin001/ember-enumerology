sortBy = Enumerology.FilterBy.extend
  apply: (target, collection)->
    compareFunction = @get('compareFunction')
    key = @get('key')
    collection.slice(0).sort (a,b)->
      compareFunction(a.get(key), b.get(key))

Enumerology.Transform.SortBy = sortBy
