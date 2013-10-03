take = Enumerology.Filter.extend
  apply: (target, collection)->
    collection.slice(0,@get('howMany'))

Enumerology.Transform.Take = take
