run = Em.run

describe 'Acceptance', ->
  describe 'slice', ->
    object     = undefined
    collection = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']

    createSlicer = (beginIndex, endIndex)->
      Em.Object.createWithMixins
        collection: collection
        property:   Enumerology.create('collection').slice(beginIndex, endIndex).finalize()

    describe 'when the beginning and end are positive integers', ->
      beforeEach ->
        run ->
          object = createSlicer(1,3)

      it 'slices', ->
        expect(object.get('property')).toEqual(['B', 'C'])

    describe 'when the beginning is a positive integer, and the end is undefined', ->
      beforeEach ->
        run ->
          object = createSlicer(3)

      it 'slices', ->
        expect(object.get('property')).toEqual(["D", "E", "F", "G", "H", "I", "J"])

    describe 'when the beginning is a negative integer, and the end is undefined', ->
      beforeEach ->
        run ->
          object = createSlicer(-3)

      it 'slices', ->
        expect(object.get('property')).toEqual(["H", "I", "J"])
