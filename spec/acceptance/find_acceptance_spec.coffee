run = Em.run

describe 'Acceptance', ->
  describe 'find', ->
    object = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').find((i)-> i.toUpperCase() == i).finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is undefined', ->
        expect(object.get('property')).toEqual(undefined)

    describe 'when a matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('A')

      it 'returns the first object', ->
        expect(object.get('property')).toEqual('A')

    describe 'when multiple matching items are added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['Z', 'A'])

      it 'returns the first object', ->
        expect(object.get('property')).toEqual('Z')

    describe 'when a non-matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('z')

      it 'is undefined', ->
        expect(object.get('property')).toEqual(undefined)
