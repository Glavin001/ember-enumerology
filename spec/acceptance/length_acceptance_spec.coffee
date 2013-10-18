run = Em.run

describe 'Acceptance', ->
  describe 'length', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.extend(
          collection: Em.A()
          property: Enumerology.create('collection').length().finalize()
        ).create()
        object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is zero', ->
        expect(object.get('property')).toEqual(0)

    describe 'when an object is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('a')

      it 'returns the object', ->
        expect(object.get('property')).toEqual(1)

    describe 'when multiple objects are added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'b', 'c'])

      it 'returns the last object', ->
        expect(object.get('property')).toEqual(3)

      describe 'when the last object is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(2)

        it 'returns the next-last object', ->
          expect(object.get('property')).toEqual(2)
