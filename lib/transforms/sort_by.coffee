lexigraphicCompare = (a,b)->
  _a = a.toString()
  _b = b.toString()
  if _a == _b
    0
  else if _a > _b
    1
  else if _a < _b
    -1

sortBy = Enumerology.TransformBy.extend
  apply: (target, collection)->
    compareFunction = @getWithDefault('compareFunction', lexigraphicCompare)
    key = @get('key')
    collection.slice(0).sort (a,b)->
      compareFunction(a.get(key), b.get(key))

Enumerology.Transform.SortBy = sortBy
