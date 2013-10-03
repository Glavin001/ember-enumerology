run = Em.run

describe 'Acceptance', ->
  describe 'contains', ->
    object = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').contains('a').finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is false', ->
        expect(object.get('property')).toBe(false)

    describe 'when a non-matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject('b')

      it 'is false', ->
        expect(object.get('property')).toBe(false)

    describe 'when a matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject('a')

      it 'is true', ->
        expect(object.get('property')).toBe(true)

    describe 'when the dependent key contains matching and non-matching values', ->
      beforeEach -> run ->
        object.get('collection').pushObjects(['a', 'a', 'b', 'b'])

      describe 'when the penultimate matching item is removed', ->
        beforeEach -> run ->
          object.get('collection').removeAt(0, 1)

        it 'is true', ->
          expect(object.get('property')).toBe(true)

      describe 'when the last matching item is removed', ->
        beforeEach -> run ->
          object.get('collection').removeAt(0, 2)

        it 'is false', ->
          expect(object.get('property')).toBe(false)

      describe 'when a non-matching item is removed', ->
        beforeEach -> run ->
          object.get('collection').removeAt(2,1)

        it 'is true', ->
          expect(object.get('property')).toBe(true)


