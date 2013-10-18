run = Em.run

objectWithName = (name)-> Em.Object.create(name: name)

describe 'Acceptance', ->
  describe 'everyBy', ->
    object = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').everyBy('name', 'Marty').finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is true', ->
        expect(object.get('property')).toBe(true)

    describe 'when a non-matching item is added', ->
      beforeEach ->
        run ->
        object.get('collection').pushObject(objectWithName('Biff'))

      it 'is false', ->
        expect(object.get('property')).toBe(false)

    describe 'when a matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject(objectWithName('Marty'))

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
            object.get('collection').pushObject(objectWithName('Biff'))

        it 'is false', ->
          expect(object.get('property')).toBe(false)
