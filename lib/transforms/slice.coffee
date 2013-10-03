slice = Enumerology.FilterBy.extend
  apply: (target, collection)->
    begin = @get('begin')
    end   = @get('end')

    if Em.isEmpty(end)
      collection.slice(begin)
    else
      collection.slice(begin,end)

Enumerology.Transform.Slice = slice
