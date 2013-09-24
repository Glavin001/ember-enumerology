run = Em.run

describe 'acceptance', ->
  describe 'filter', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          filteredCollection: Enumerology.create('collection').filter((item)-> item.toUpperCase() == item).finalize()
        # Force computed property to be created
        object.get('filteredCollection')

    describe 'when the dependent array is empty', ->
      it 'has length zero', ->
        expect(object.get('filteredCollection.length')).toEqual(0)

    describe 'when a matching item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('A')

      it 'is appended to the array', ->
        expect(object.get('filteredCollection')).toEqual(['A'])

    describe 'when a non-matching item is appended to the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('b')

      it 'is not appended to the array', ->
        expect(object.get('filteredCollection')).toEqual([])

    describe 'a matching item is inserted before existing matching items in the dependent array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'A', 'b', 'B'])
          expect(object.get('filteredCollection')).toEqual(['A', 'B'])
          object.get('collection').insertAt(2, 'C')

      it 'is inserted in the array, preserving order', ->
        expect(object.get('filteredCollection')).toEqual(['A', 'C', 'B'])

    describe 'when the dependent array contains matching and non-matching items', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'A', 'B', 'A', 'b', 'B'])

      describe 'when a non-matching item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(4, 1)

        it 'remains unchanged', ->
          expect(object.get('filteredCollection')).toEqual(['A', 'B', 'A', 'B'])

      describe 'when non-matching and matching items are removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(0, 1) # remove 'a'
            object.get('collection').removeAt(1, 1) # remove 'B'

        it 'has the corresponding matching item removed', ->
          expect(object.get('filteredCollection')).toEqual(['A', 'A', 'B'])

      describe 'when a matching item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(2, 1) # remove the first 'B'

        it 'has the corresponding matching item removed', ->
          expect(object.get('filteredCollection')).toEqual(['A', 'A', 'B'])

      describe 'when a duplicate matching item is removed', ->
        beforeEach ->
          run ->
            object.get('collection').removeAt(5, 1) # remove the second 'B'

        it 'has the corresponding matching item removed', ->
          expect(object.get('filteredCollection')).toEqual(['A', 'B', 'A'])

  describe 'an enumerology of two filters', ->
    object = undefined

    beforeEach ->
      run ->
        isUpperCase = (item)-> item.toUpperCase() == item
        isVowel = (item) -> /[aeiuo]/i.test(item)

        object = Em.Object.createWithMixins
          collection: Em.A()
          filteredCollection: Enumerology.create('collection').filter(isUpperCase).filter(isVowel).finalize()
        # Force computed property to be created
        object.get('filteredCollection')

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('filteredCollection')).toEqual([])

    describe 'when a partially matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['Q', 'e'])

      it 'is not added to the array', ->
        expect(object.get('filteredCollection')).toEqual([])

    describe 'when a fully matching item is added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject('E')

      it 'is added to the array', ->
        expect(object.get('filteredCollection')).toEqual(['E'])

    describe 'when the dependent array contains a mix of fully matching, partially matching and non-matching items', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects(['a', 'q', 'E', 'Z', 'b', 'U'])
          expect(object.get('filteredCollection')).toEqual(['E', 'U'])

      describe 'and a fully matching item is added', ->
        it 'is added the the array, preserving order', ->

