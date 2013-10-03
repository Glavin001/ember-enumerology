run = Em.run
objectWithName = (name)-> Em.Object.createWithMixins(name: name)

describe 'Acceptance', ->
  describe 'emptyBy', ->
    object = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').emptyBy('name').finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is true', ->
        expect(object.get('property')).toBe(true)

    describe 'when an item with an empty property is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject(objectWithName(null))

      it 'is true', ->
        expect(object.get('property')).toBe(true)

    describe 'when an item with a non-empty property is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject(objectWithName('Biff'))

      it 'is false', ->
        expect(object.get('property')).toBe(false)
