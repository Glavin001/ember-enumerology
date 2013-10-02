run = Em.run

describe 'Acceptance', ->
  describe 'filter chains', ->
    describe 'filter.map', ->
      object = undefined

      beforeEach ->
        run ->
          object = Em.Object.createWithMixins
            collection: Em.A()
            computed:   Enumerology.create('collection').filter((i)-> i.toUpperCase() == i).map((i)-> i.toLowerCase()).finalize()

      describe 'when a non-matching item is added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject('a')

        it 'is not added to the array', ->
          expect(object.get('computed')).toEqual([])

      describe 'when a matching item is added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject('A')

        it 'is added and transformed', ->
          expect(object.get('computed')).toEqual(['a'])

      describe 'when a mix of matching and non-matching items are added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObjects(['A', 'b', 'C', 'd'])

        it 'is added and transformed', ->
          expect(object.get('computed')).toEqual(['a', 'c'])

        describe 'when non-matching items are removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(3)
              object.get('collection').removeAt(1)

          it "doesn't change the result", ->
            expect(object.get('computed')).toEqual(['a', 'c'])

        describe 'when matching items are removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          it 'is removed, preserving order', ->
            expect(object.get('computed')).toEqual(['c'])
