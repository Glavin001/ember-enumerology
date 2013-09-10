take = Enumerology.Transform.extend
  apply: (target, collection)->
    collection.slice(0,@get('howMany'))

Enumerology.Transform.Take = take
