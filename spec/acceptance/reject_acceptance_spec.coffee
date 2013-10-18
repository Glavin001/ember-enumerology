run = Em.run

describe 'Acceptance', ->
  describe 'reject', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          rejectedCollection: Enumerology.create('collection').reject((item)-> item.toUpperCase() == item).finalize()
        # Force computed property to be created
        object.get('rejectedCollection')

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('rejectedCollection')).toEqual(Em.A())

    describe 'when a matching item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('A')

      it 'is not appended to the array', ->
        expect(object.get('rejectedCollection')).toEqual(Em.A())

    describe 'when a non-matching item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('b')

      it 'is appended to the array', ->
        expect(object.get('rejectedCollection')).toEqual(['b'])

    describe 'a non-matching item is inserted before existing matching items in the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'A', 'b', 'B'])
          expect(object.get('rejectedCollection')).toEqual(['a', 'b'])
          object.get('collection').insertAt(2, 'c')

      it 'is inserted in the array, preserving order', ->
        expect(object.get('rejectedCollection')).toEqual(['a', 'c', 'b'])

    describe 'when the dependent array contains matching and non-matching items', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'A', 'B', 'A', 'b', 'B'])

      describe 'when a non-matching item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(3, 1)

        it 'remains unchanged', ->
          expect(object.get('rejectedCollection')).toEqual(['a', 'b'])

      describe 'when non-matching and matching items are removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(0, 1) # remove 'a'
            object.get('collection').removeAt(1, 1) # remove 'B'

        it 'has the corresponding matching item removed', ->
          expect(object.get('rejectedCollection')).toEqual(['b'])

      describe 'when a matching item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(4, 1) # remove the 'b'

        it 'has the corresponding matching item removed', ->
          expect(object.get('rejectedCollection')).toEqual(['a'])

