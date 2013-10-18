toSentence = Enumerology.Reduce.extend
  initialValue: ''

  addedItem: (accumulatedValue, item, context)->
    collection = context.arrayChanged
    list = collection.slice(0,-1)
    last = collection.slice(-1)
    conjunction = @get('conjunction')
    oxfordComma = if @get('oxfordComma') then ',' else ''
    "#{list.join(', ')}#{oxfordComma} #{conjunction} #{last}"

  removedItem: (accumulatedValue, item, context)->
    collection = context.arrayChanged
    list = collection.slice(0,-1)
    last = collection.slice(-1)
    conjunction = @get('conjunction')
    oxfordComma = if @get('oxfordComma') then ',' else ''
    "#{list.join(', ')}#{oxfordComma} #{conjunction} #{last}"

Enumerology.Transform.ToSentence = toSentence
