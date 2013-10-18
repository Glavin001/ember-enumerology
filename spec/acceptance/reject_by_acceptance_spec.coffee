run = Em.run
potentiallyAwesomeObject = (awesome)-> Em.Object.createWithMixins(isAwesome: awesome)

describe 'Acceptance', ->
  describe 'rejectBy', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          rejectedCollection: Enumerology.create('collection').rejectBy('isAwesome', true).finalize()
        # Force computed property to be created
        object.get('rejectedCollection')

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('rejectedCollection')).toEqual(Em.A())

    describe 'when a non-matching item is appended to the dependent array', ->
      nonMatch = undefined

      beforeEach ->
        run ->
          nonMatch = potentiallyAwesomeObject(false)
          object.get('collection').pushObject(nonMatch)

      it 'is appended to the array', ->
        expect(object.get('rejectedCollection')).toEqual([nonMatch])

    describe 'when a matching item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(potentiallyAwesomeObject(true))

      it 'is not appended to the array', ->
        expect(object.get('rejectedCollection')).toEqual([])

