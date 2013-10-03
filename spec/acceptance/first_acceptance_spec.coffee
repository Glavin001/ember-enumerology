run = Em.run

describe 'Acceptance', ->
  describe 'first', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.extend(
          collection: Em.A()
          property: Enumerology.create('collection').first().finalize()
        ).create()
        # computed properties are lazy: make sure it has already been created
        object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is undefined', ->
        expect(object.get('property')).toBeUndefined()

    describe 'when an object is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('a')

      it 'returns the object', ->
        expect(object.get('property')).toEqual('a')

    describe 'when multiple objects are added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'b', 'c'])

      it 'returns the first object', ->
        expect(object.get('property')).toEqual('a')

      describe 'when the first object is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(0)

        it 'returns the next-first object', ->
          expect(object.get('property')).toEqual('b')
