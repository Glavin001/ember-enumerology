run = Em.run
objectWithName = (name)-> Em.Object.createWithMixins(name: name)

describe 'Acceptance', ->
  describe 'mapBy', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          mappedCollection: Enumerology.create('collection').mapBy('name').finalize()

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('mappedCollection')).toEqual(Em.A())

    describe 'when an item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(objectWithName('Marty'))

      it 'is transformed and appended to the array', ->
        expect(object.get('mappedCollection')).toEqual(['Marty'])

    describe 'when multiple items are appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([objectWithName('Marty'), objectWithName('Doc'), objectWithName('Biff')])

      it 'is transformed and appended to the array', ->
        expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc', 'Biff'])

    describe 'when an item is inserted before existing items', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([objectWithName('Marty'), objectWithName('Doc'), objectWithName('Biff')])
          expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc', 'Biff'])
          object.get('collection').insertAt(2, objectWithName('Lorraine'))

      it 'is transformed at inserted, preserving order', ->
        expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc', 'Lorraine', 'Biff'])

    describe 'when an item is removed from the end of the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([objectWithName('Marty'), objectWithName('Doc'), objectWithName('Biff')])
          expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc', 'Biff'])
          object.get('collection').popObject()

      it 'is removed', ->
        expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc'])

    describe 'when an item is removed from the beginning of the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([objectWithName('Marty'), objectWithName('Doc'), objectWithName('Biff')])
          expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc', 'Biff'])
          object.get('collection').shiftObject()

      it 'is removed, preserving order', ->
        expect(object.get('mappedCollection')).toEqual(['Doc', 'Biff'])

    describe 'when an item is removed from the middle of the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([objectWithName('Marty'), objectWithName('Doc'), objectWithName('Biff')])
          expect(object.get('mappedCollection')).toEqual(['Marty', 'Doc', 'Biff'])
          object.get('collection').removeAt(1)

      it 'is removed, preserving order', ->
        expect(object.get('mappedCollection')).toEqual(['Marty', 'Biff'])
