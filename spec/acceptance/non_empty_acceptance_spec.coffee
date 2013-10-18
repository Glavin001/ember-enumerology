run = Em.run

describe 'Acceptance', ->
  describe 'nonEmpty', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.extend(
          collection: [],
          property: Enumerology.create('collection').nonEmpty().finalize()
        ).create()
        # computed properties are lazy: make sure it has already been created
        object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is false', ->
        expect(object.get('property')).toBe(false)

    describe 'when an item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('a')

      it 'is true', ->
        expect(object.get('property')).toBe(true)

      describe 'and then removed again', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(0)

        it 'is false', ->
          expect(object.get('property')).toBe(false)
