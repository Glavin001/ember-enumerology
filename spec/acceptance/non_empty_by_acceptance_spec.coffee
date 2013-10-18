run = Em.run
objectWithName = (name) -> Em.Object.create(name: name)

describe 'Acceptance', ->
  describe 'nonEmptyBy', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.extend(
          collection: [],
          property: Enumerology.create('collection').nonEmptyBy('name').finalize()
        ).create()
        # computed properties are lazy: make sure it has already been created
        object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is false', ->
        expect(object.get('property')).toBe(false)

    describe 'when a matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(objectWithName('Marty'))

      it 'is true', ->
        expect(object.get('property')).toBe(true)

      describe 'and then removed again', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(0)

        it 'is false', ->
          expect(object.get('property')).toBe(false)

    describe 'when a non-matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(objectWithName(undefined))

      it 'is false', ->
        expect(object.get('property')).toBe(false)
