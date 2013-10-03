run = Em.run

describe 'Acceptance', ->
  describe 'empty', ->
    object = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').empty().finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is true', ->
        expect(object.get('property')).toBe(true)

    describe 'when an item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject('a')

      it 'is false', ->
        expect(object.get('property')).toBe(false)
