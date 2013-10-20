run = Em.run

describe 'Acceptance', ->
  describe 'skip', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').skip(10).finalize()

    describe 'when the collection is empty', ->

      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when there are less than 10 objects in the collection', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([1,2,3,4,5,6,7,8])

      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when there are more than 10 objects in the collection', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])

      it 'contains only the objects after the first 10', ->
        expect(object.get('property')).toEqual([11,12,13,14,15])
