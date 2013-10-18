run = Em.run

describe 'Acceptance', ->
  describe 'uniq', ->

    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').uniq().finalize()

    describe 'when the collection is empty', ->
      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when items are added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['A', 'A', 'A', 'B', 'B', 'C', 'D', 'D', 'D', 'D'])

      it 'returns only unique elements', ->
        expect(object.get('property')).toEqual(['A', 'B', 'C', 'D'])

      describe 'when an item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(5)

        it 'returns the unique elements', ->
          expect(object.get('property')).toEqual(['A', 'B', 'D'])

