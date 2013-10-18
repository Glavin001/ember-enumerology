run = Em.run

describe 'Acceptance', ->
  describe 'take', ->

    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').take(3).finalize()

    describe 'when the array is empty', ->
      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when the two items are added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([1,2])

      it 'adds them to the result', ->
        expect(object.get('property')).toEqual([1,2])

      describe 'when two more items are added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObjects([3,4])

        it 'adds only the first', ->
          expect(object.get('property')).toEqual([1,2,3])

        describe 'when one item is removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          it 'removes the first, and adds the last', ->
            expect(object.get('property')).toEqual([2,3,4])

