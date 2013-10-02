run = Em.run

describe 'Acceptance', ->
  describe 'compact', ->

    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          compact:    Enumerology.create('collection').compact().finalize()

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('compact')).toEqual(Em.A())

    describe 'when a null item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(null)

      it 'is empty', ->
        expect(object.get('compact')).toEqual(Em.A())

    describe 'when an undefined item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(undefined)

      it 'is empty', ->
        expect(object.get('compact')).toEqual(Em.A())

    describe 'when a defined item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('foo')

      it 'is added to the array', ->
        expect(object.get('compact')).toEqual(['foo'])

