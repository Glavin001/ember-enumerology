run = Em.run

describe 'Acceptance', ->

  object = null
  beforeEach -> object = null
  afterEach  -> object = null

  castMember = Em.Object.extend
    nameLength: (-> @get('name.length') ).property('name')

  objectWithComputed = (func)->
    Em.Object.extend(
      characters: ['Marty', 'Doc', 'Jennifer', null]
      cast: [castMember.create(name: 'Michael J. Fox'), castMember.create(name: 'Christopher Lloyd'), castMember.create(name: 'Claudia Wells')]
      computed: func()
    ).create()

  itCalculatesCorrectly = (name, func, result)->
    describe name, ->
      beforeEach ->
        run ->
          object = objectWithComputed func
      it 'calculates the correct result', ->
        run ->
          expect(object.get('computed')).toEqual(result)

  itCalculatesCorrectly 'any', (-> Enumerology.create('characters').any((i)-> i == "Marty").finalize()), true
  itCalculatesCorrectly 'anyBy', (-> Enumerology.create('cast').anyBy('name', 'Michael J. Fox').finalize()), true
  itCalculatesCorrectly 'compact', (-> Enumerology.create('characters').compact().finalize()), ['Marty', 'Doc', 'Jennifer']
  itCalculatesCorrectly 'compactBy', (-> Enumerology.create('cast').invoke('set', 'name',null).compactBy('name').empty().finalize()), true
  itCalculatesCorrectly 'contains', (-> Enumerology.create('characters').contains('Marty').finalize()), true
  itCalculatesCorrectly 'empty', (-> Enumerology.create('nonExistantKey').empty().finalize()), true
  itCalculatesCorrectly 'empty', (-> Enumerology.create('characters').empty().finalize()), false
  itCalculatesCorrectly 'emptyBy', (-> Enumerology.create('cast').emptyBy('foo').finalize()), true
  itCalculatesCorrectly 'emptyBy', (-> Enumerology.create('cast').emptyBy('name').finalize()), false
  itCalculatesCorrectly 'every', (-> Enumerology.create('characters').compact().every((i)-> i.length > 2).finalize()), true
  itCalculatesCorrectly 'everyBy', (-> Enumerology.create('cast').everyBy('name', 'Michael J. Fox').finalize()), false
  itCalculatesCorrectly 'filter', (-> Enumerology.create('characters').filter((i)-> i == 'Marty').finalize()), ['Marty']
  itCalculatesCorrectly 'filterBy', (-> Enumerology.create('cast').filterBy('name', 'Michael J. Fox').length().finalize()), 1
  itCalculatesCorrectly 'find', (-> Enumerology.create('characters').find((i)-> i == 'Marty').finalize()), 'Marty'
  itCalculatesCorrectly 'findBy', (-> Enumerology.create('cast').filterBy('name', 'Claudia Wells').findBy('name', 'Michael J. Fox').finalize()), null
  itCalculatesCorrectly 'first', (-> Enumerology.create('characters').first().finalize()), 'Marty'
  itCalculatesCorrectly 'invoke', (-> Enumerology.create('cast').invoke('set', 'name', 'Crispin Glover').mapBy('name').finalize()), ['Crispin Glover', 'Crispin Glover', 'Crispin Glover']
  itCalculatesCorrectly 'join', (-> Enumerology.create('characters').compact().join(', ').finalize()), 'Marty, Doc, Jennifer'
  itCalculatesCorrectly 'last', (-> Enumerology.create('characters').compact().last().finalize()), 'Jennifer'
  itCalculatesCorrectly 'length', (-> Enumerology.create('cast').length().finalize()), 3
  itCalculatesCorrectly 'map', (-> Enumerology.create('characters').compact().map((i)-> i.toUpperCase()).finalize()), ['MARTY', 'DOC', 'JENNIFER']
  itCalculatesCorrectly 'mapBy', (-> Enumerology.create('cast').compact().mapBy('name').finalize()), ['Michael J. Fox', 'Christopher Lloyd', 'Claudia Wells']
  itCalculatesCorrectly 'nonEmpty', (-> Enumerology.create('characters').nonEmpty().finalize()), true
  itCalculatesCorrectly 'nonEmpty', (-> Enumerology.create('nonExistantKey').nonEmpty().finalize()), false
  itCalculatesCorrectly 'nonEmptyBy', (-> Enumerology.create('cast').nonEmptyBy('name').finalize()), true
  itCalculatesCorrectly 'nonEmptyBy', (-> Enumerology.create('cast').nonEmptyBy('foo').finalize()), false
  itCalculatesCorrectly 'reduce', (-> Enumerology.create('characters').compact().reduce(((sum,i)-> sum += i.length), 0).finalize()), 16
  itCalculatesCorrectly 'reject', (-> Enumerology.create('characters').reject((i)-> i == null).length().finalize()), 3
  itCalculatesCorrectly 'rejectBy', (-> Enumerology.create('cast').rejectBy('name', 'Christopher Lloyd').length().finalize()), 2
  itCalculatesCorrectly 'reverse', (-> Enumerology.create('characters').compact().reverse().finalize()), ['Jennifer', 'Doc', 'Marty']
  itCalculatesCorrectly 'sort', (-> Enumerology.create('characters').compact().sort().finalize()), ['Doc', 'Jennifer', 'Marty']
  itCalculatesCorrectly 'sortBy', (-> Enumerology.create('cast').sortBy('name').mapBy('name').finalize()), [ 'Christopher Lloyd', 'Claudia Wells', 'Michael J. Fox' ]
  itCalculatesCorrectly 'sortNumerically', (-> Enumerology.create('cast').mapProperty('nameLength').sortNumerically().finalize()), [ 13, 14, 17 ]
  itCalculatesCorrectly 'sortNumericallyBy', (-> Enumerology.create('cast').sortNumericallyBy('nameLength').mapProperty('nameLength').finalize()), [ 13, 14, 17 ]
  itCalculatesCorrectly 'slice', (-> Enumerology.create('characters').slice(1,3).finalize()), ['Doc', 'Jennifer']
  itCalculatesCorrectly 'take', (-> Enumerology.create('characters').take(2).finalize()), ['Marty', 'Doc']
  itCalculatesCorrectly 'toSentence', (-> Enumerology.create('characters').compact().toSentence().finalize()), 'Marty, Doc and Jennifer'
