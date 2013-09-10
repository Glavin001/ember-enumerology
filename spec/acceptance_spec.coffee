run = Em.run

describe 'Acceptance', ->

  object = null
  beforeEach -> object = null
  afterEach  -> object = null

  objectWithComputed = (func)->
    Em.Object.extend(
      characters: ['Marty', 'Doc', 'Jennifer', null]
      cast: [Em.Object.create(name: 'Michael J. Fox'), Em.Object.create(name: 'Christopher Lloyd'), Em.Object.create(name: 'Claudia Wells')]
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
  itCalculatesCorrectly 'contains', (-> Enumerology.create('characters').contains('Marty').finalize()), true
  itCalculatesCorrectly 'every', (-> Enumerology.create('characters').compact().every((i)-> i.length > 2).finalize()), true
  itCalculatesCorrectly 'everyBy', (-> Enumerology.create('cast').everyBy('name', 'Michael J. Fox').finalize()), false
  itCalculatesCorrectly 'filter', (-> Enumerology.create('characters').filter((i)-> i == 'Marty').finalize()), ['Marty']
  itCalculatesCorrectly 'filterBy', (-> Enumerology.create('cast').filterBy('name', 'Michael J. Fox').length().finalize()), 1
  itCalculatesCorrectly 'find', (-> Enumerology.create('characters').find((i)-> i == 'Marty').finalize()), 'Marty'
  itCalculatesCorrectly 'findBy', (-> Enumerology.create('cast').filterBy('name', 'Claudia Wells').findBy('name', 'Michael J. Fox').finalize()), null
  itCalculatesCorrectly 'invoke', (-> Enumerology.create('cast').invoke('get', 'name').finalize()), ['Michael J. Fox', 'Christopher Lloyd', 'Claudia Wells']
  itCalculatesCorrectly 'join', (-> Enumerology.create('characters').compact().join(', ').finalize()), 'Marty, Doc, Jennifer'
  itCalculatesCorrectly 'length', (-> Enumerology.create('cast').length().finalize()), 3
  itCalculatesCorrectly 'map', (-> Enumerology.create('characters').compact().map((i)-> i.toUpperCase()).finalize()), ['MARTY', 'DOC', 'JENNIFER']
  itCalculatesCorrectly 'mapBy', (-> Enumerology.create('cast').compact().mapBy('name').finalize()), ['Michael J. Fox', 'Christopher Lloyd', 'Claudia Wells']
  itCalculatesCorrectly 'reduce', (-> Enumerology.create('characters').compact().reduce(((sum,i)-> sum += i.length), 0).finalize()), 16
  itCalculatesCorrectly 'reject', (-> Enumerology.create('characters').reject((i)-> i == null).length().finalize()), 3
  itCalculatesCorrectly 'rejectBy', (-> Enumerology.create('cast').rejectBy('name', 'Christopher Lloyd').length().finalize()), 2
  itCalculatesCorrectly 'setEach', (-> Enumerology.create('cast').setEach('name', 'Biff').filterBy('name', 'Biff').length().finalize()), 3
  itCalculatesCorrectly 'toSentence', (-> Enumerology.create('characters').compact().toSentence().finalize()), 'Marty, Doc and Jennifer'
  itCalculatesCorrectly 'uniq', (-> Enumerology.create('cast').setEach('name', 'Biff').mapBy('name').uniq().finalize()), ['Biff']
