run = Em.run
potentiallyAwesomeObject = (awesome)-> Em.Object.createWithMixins(isAwesome: awesome)

describe 'Acceptance', ->
  describe 'filterBy', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          filteredCollection: Enumerology.create('collection').filterBy('isAwesome', true).finalize()
        # Force computed property to be created
        object.get('filteredCollection')

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('filteredCollection')).toEqual(Em.A())

    describe 'when a matching item is appended to the dependent array', ->
      match = undefined

      beforeEach ->
        run ->
          match = potentiallyAwesomeObject(true)
          object.get('collection').pushObject(match)

      it 'is appended to the array', ->
        expect(object.get('filteredCollection')).toEqual([match])

    describe 'when a non-matching item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(potentiallyAwesomeObject(false))

      it 'is not appended to the array', ->
        expect(object.get('filteredCollection')).toEqual([])

