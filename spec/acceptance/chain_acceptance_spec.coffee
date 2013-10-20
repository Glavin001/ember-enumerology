run = Em.run
objectWithName = (name)-> Em.Object.create(name: name)

describe 'Acceptance', ->
  describe 'filter chains', ->
    describe 'filter.map', ->
      object = undefined

      beforeEach ->
        run ->
          object = Em.Object.createWithMixins
            collection: Em.A()
            property:   Enumerology.create('collection').filter((i)-> i.toUpperCase() == i).map((i)-> i.toLowerCase()).finalize()

      describe 'when a non-matching item is added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject('a')

        it 'is not added to the array', ->
          expect(object.get('property')).toEqual([])

      describe 'when a matching item is added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject('A')

        it 'is added and transformed', ->
          expect(object.get('property')).toEqual(['a'])

      describe 'when a mix of matching and non-matching items are added', ->
        beforeEach ->
          run ->
            object.get('collection').pushObjects(['A', 'b', 'C', 'd'])

        it 'is added and transformed', ->
          expect(object.get('property')).toEqual(['a', 'c'])

        describe 'when non-matching items are removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(3)
              object.get('collection').removeAt(1)

          it "doesn't change the result", ->
            expect(object.get('property')).toEqual(['a', 'c'])

        describe 'when matching items are removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          it 'is removed, preserving order', ->
            expect(object.get('property')).toEqual(['c'])

    describe 'compact.mapBy.uniq, some', ->
      object = undefined

      beforeEach ->
        run ->
          object = Em.Object.createWithMixins
            collection: Em.A()
            property1:  Enumerology.create('collection').compact().mapBy('name').uniq().finalize()
            property2:  Enumerology.create('property1').some().finalize()

      describe 'when the collection is empty', ->
        describe 'property1', ->
          it 'is empty', ->
            expect(object.get('property1')).toEqual(Em.A())

        describe 'property2', ->
          it 'is false', ->
            expect(object.get('property2')).toBe(false)

      describe 'when undefined is added to the collection', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject(undefined)

        describe 'property1', ->
          it 'is empty', ->
            expect(object.get('property1')).toEqual(Em.A())

        describe 'property2', ->
          it 'is false', ->
            expect(object.get('property2')).toBe(false)

      describe 'when null is added to the collection', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject(null)

        describe 'property1', ->
          it 'is empty', ->
            expect(object.get('property1')).toEqual(Em.A())

        describe 'property2', ->
          it 'is false', ->
            expect(object.get('property2')).toBe(false)

      describe 'when an object with a name property is added to the collection', ->
        beforeEach ->
          run ->
            object.get('collection').pushObject(objectWithName('Lea Thompson'))

        describe 'property1', ->
          it 'is included in the result', ->
            expect(object.get('property1')).toEqual(['Lea Thompson'])

        describe 'property2', ->
          it 'is true', ->
            expect(object.get('property2')).toBe(true)

        describe 'and then it is removed again', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          describe 'property1', ->
            it 'is empty', ->
              expect(object.get('property1')).toEqual(Em.A())

          describe 'property2', ->
            it 'is false', ->
              expect(object.get('property2')).toBe(false)

      describe 'when multiple objects with name properties are added to the collection', ->
        beforeEach ->
          run ->
            ['Lea Thompson', 'Christopher Lloyd', 'Thomas F. Wilson', 'Lea Thompson', 'Christopher Lloyd', 'Claudia Wells'].forEach (i)->
              object.get('collection').pushObject(objectWithName(i))

        describe 'property1', ->
          it 'contains only unique values', ->
            expect(object.get('property1')).toEqual(['Lea Thompson', 'Christopher Lloyd', 'Thomas F. Wilson', 'Claudia Wells'])

        describe 'property2', ->
          it 'is true', ->
            expect(object.get('property2')).toBe(true)

        describe 'when a non-unique element is removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(0)

          describe 'property1', ->
            it 'contains only the remaining unique values', ->
              expect(object.get('property1')).toEqual(['Christopher Lloyd', 'Thomas F. Wilson', 'Lea Thompson', 'Claudia Wells'])

          describe 'property2', ->
            it 'is true', ->
              expect(object.get('property2')).toBe(true)

        describe 'when a unique element is removed', ->
          beforeEach ->
            run ->
              object.get('collection').removeAt(2)

          describe 'property1', ->
            it 'contains only the remaining unique values', ->
              expect(object.get('property1')).toEqual(['Lea Thompson', 'Christopher Lloyd', 'Claudia Wells'])

          describe 'property2', ->
            it 'is true', ->
              expect(object.get('property2')).toBe(true)
