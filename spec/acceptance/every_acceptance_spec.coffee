run = Em.run

describe 'Acceptance', ->
  describe 'every', ->
    object = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').every((i)-> i.toUpperCase() == i).finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is true', ->
        expect(object.get('property')).toBe(true)

    describe 'when a non-matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject('b')

      it 'is false', ->
        expect(object.get('property')).toBe(false)

    describe 'when a matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject('A')

      it 'is true', ->
        expect(object.get('property')).toBe(true)

      describe 'and it is removed again', ->
        beforeEach ->
          run ->
            object.get('collection').popObject()

        it 'is true', ->
          expect(object.get('property')).toBe(true)

      describe 'and a non-matching item is added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject('c')

        it 'is false', ->
          expect(object.get('property')).toBe(false)

