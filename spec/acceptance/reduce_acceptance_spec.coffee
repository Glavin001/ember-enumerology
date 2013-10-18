run = Em.run
reductionFunction = (previousValue, item, index, enumerable)->
  previousValue += item

describe 'Acceptance', ->
  describe 'reduce', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').reduce(reductionFunction, 0).finalize()

    it 'should be 0', ->
      expect(object.get('property')).toEqual(0)

    describe 'when 10 is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(10)

      it 'should be 10', ->
        expect(object.get('property')).toEqual(10)

      describe 'when 5 is addded', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject(5)

        it 'should be 15', ->
          expect(object.get('property')).toEqual(15)

        describe 'when 10 is removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          it 'should be 5', ->
            expect(object.get('property')).toEqual(5)
