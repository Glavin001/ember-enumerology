run = Em.run
potentiallyAwesomeObject = (isAwesome)-> Em.Object.createWithMixins(isAwesome: isAwesome)

describe 'Acceptance', ->
  describe 'findBy', ->
    object   = undefined
    testItem = undefined

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: [],
        property: Enumerology.create('collection').findBy('isAwesome', true).finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      it 'is undefined', ->
        expect(object.get('property')).toEqual(undefined)

    describe 'when a matching item is added', ->
      beforeEach ->
        run ->
          testItem = potentiallyAwesomeObject(true)
          object.get('collection').pushObject(testItem)

      it 'returns the first object', ->
        expect(object.get('property')).toEqual(testItem)

    describe 'when multiple matching items are added', ->
      beforeEach ->
        run ->
          testItem = [potentiallyAwesomeObject(true), potentiallyAwesomeObject(true)]
          object.get('collection').pushObjects(testItem)

      it 'returns the first object', ->
        expect(object.get('property')).toEqual(testItem[0])

    describe 'when a non-matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(potentiallyAwesomeObject(false))

      it 'is undefined', ->
        expect(object.get('property')).toEqual(undefined)
