take = Enumerology.Filter.extend
  addedItem: (array, item, context)->
    context.arrayChanged.slice(0,@get('howMany'))

  removedItem: (array, item, context)->
    context.arrayChanged.slice(0,@get('howMany'))

Enumerology.Transform.Take = take
