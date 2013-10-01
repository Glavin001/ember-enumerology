run = Em.run

describe 'Acceptance', ->
  describe 'map', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          mappedCollection: Enumerology.create('collection').map((item)-> item.toUpperCase()).finalize()

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('mappedCollection')).toEqual(Em.A())

    describe 'when an item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('a')

      it 'is transformed and appended to the array', ->
        expect(object.get('mappedCollection')).toEqual(['A'])

    describe 'when multiple items are appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'B', 'c'])

      it 'is transformed and appended to the array', ->
        expect(object.get('mappedCollection')).toEqual(['A', 'B', 'C'])

    describe 'when an item is inserted before existing items', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'B', 'c'])
          expect(object.get('mappedCollection')).toEqual(['A', 'B', 'C'])
          object.get('collection').insertAt(2, 'Z')

      it 'is transformed at inserted, preserving order', ->
        expect(object.get('mappedCollection')).toEqual(['A', 'B', 'Z', 'C'])

    describe 'when an item is removed from the end of the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'B', 'c'])
          expect(object.get('mappedCollection')).toEqual(['A', 'B', 'C'])
          object.get('collection').popObject()

      it 'is removed', ->
        expect(object.get('mappedCollection')).toEqual(['A', 'B'])

    describe 'when an item is removed from the beginning of the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'B', 'c'])
          expect(object.get('mappedCollection')).toEqual(['A', 'B', 'C'])
          object.get('collection').shiftObject()

      it 'is removed, preserving order', ->
        expect(object.get('mappedCollection')).toEqual(['B', 'C'])

    describe 'when an item is removed from the middle of the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'B', 'c'])
          expect(object.get('mappedCollection')).toEqual(['A', 'B', 'C'])
          object.get('collection').removeAt(1)

      it 'is removed, preserving order', ->
        expect(object.get('mappedCollection')).toEqual(['A', 'C'])
