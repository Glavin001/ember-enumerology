run = Em.run
numericComparator = (a,b)->
  if a > b
    1
  else if a < b
    -1
  else
    0

objectWithValue = (i)->
  Em.Object.create(value: i)

describe 'Acceptance', ->
  describe 'sortBy', ->

    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').sortBy('value', numericComparator).finalize()

    describe 'when the array is empty', ->
      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when one item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(objectWithValue(10))

      it 'is added', ->
        expect(object.get('property.0.value')).toEqual(10)

      describe 'when an additional items are added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject(objectWithValue(50))
            object.get('collection').pushObject(objectWithValue(5))

        it 'is added in the correct position', ->
          expect(object.get('property.0.value')).toEqual(5)
          expect(object.get('property.2.value')).toEqual(50)

        describe 'when an item is removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          it 'is removed from the correct position', ->
            expect(object.get('property.0.value')).toEqual(5)
            expect(object.get('property.1.value')).toEqual(50)


