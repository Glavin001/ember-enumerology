run = Em.run

describe 'Acceptance', ->
  describe 'reverse', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').reverse().finalize()
        # Force computed property to be created
        object.get('property')

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when items are added to the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'b', 'c', 'd'])

      it 'adds them in reverse order', ->
        expect(object.get('property')).toEqual(['d', 'c', 'b', 'a'])

      describe 'when the first item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(0)

        it 'removes the last item', ->
          expect(object.get('property')).toEqual(['d', 'c', 'b'])

      describe 'when an arbitrary item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(2)

        it 'removes the correct item', ->
          expect(object.get('property')).toEqual(['d', 'b', 'a'])
