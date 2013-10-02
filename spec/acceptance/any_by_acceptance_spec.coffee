run = Em.run
objectWithName = (name)-> Em.Object.createWithMixins(name: name)

describe 'Acceptance', ->
  describe 'anyBy', ->
    object = undefined

    itIsTrue = ->
      it 'is true', ->
        expect(object.get('property')).toBe(true)

    itIsFalse = ->
      it 'is false', ->
        expect(object.get('property')).toBe(false)

    beforeEach -> run ->
      object = Em.Object.extend(
        collection: Em.A()
        property: Enumerology.create('collection').anyBy('name', 'Biff').finalize()
      ).create()
      # computed properties are lazy: make sure it has already been created
      object.get('property')

    describe 'when the dependent key is an empty array', ->
      itIsFalse()

    describe 'when a non-matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject(objectWithName('Marty'))

      itIsFalse()

    describe 'when a matching item is added', ->
      beforeEach -> run ->
        object.get('collection').pushObject(objectWithName('Biff'))

      itIsTrue()

    describe 'when the dependent key contains matching and non-matching values', ->
      beforeEach -> run ->
        object.get('collection').pushObjects([objectWithName('Marty'), objectWithName('Doc'), objectWithName('Biff'), objectWithName('Biff')])

      describe 'when the penultimate matching item is removed', ->
        beforeEach -> run ->
          object.get('collection').removeAt(2)

        itIsTrue()

      describe 'when the last matching item is removed', ->
        beforeEach -> run ->
          object.get('collection').removeAt(2,2)

        itIsFalse()

      describe 'when a non-matching item is removed', ->
        beforeEach -> run ->
          object.get('collection').removeAt(1)

        itIsTrue()

