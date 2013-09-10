run = Ember.run

describe 'Enumerology.Pipeline', ->
  pipeline = null

  beforeEach ->
    pipeline = Enumerology.Pipeline.create()

  afterEach ->
    pipeline = null

  it 'exists', ->
    expect(Enumerology.Pipeline).toBeDefined()

  describe '#init', ->
    it 'has no transformations', ->
      run ->
        expect(pipeline.get('transformations')).toEqual([])

  itIsATransformation = (name)->
    classify = (name)->
      name.charAt(0).toUpperCase() + name.slice(1)

    describe "##{name}", ->
      it "adds a #{classify(name)} transform", ->
        run ->
          pipeline[name]()
          expect(pipeline.get('transformations.lastObject').constructor).toEqual(Enumerology.Transform[classify(name)])

      it 'returns the pipeline', ->
        run ->
          expect(pipeline[name]()).toEqual(pipeline)

  itIsATransformation('any')
  itIsATransformation('anyBy')
  itIsATransformation('compact')
  itIsATransformation('contains')
  itIsATransformation('every')
  itIsATransformation('everyBy')
  itIsATransformation('filter')
  itIsATransformation('filterBy')
  itIsATransformation('find')
  itIsATransformation('findBy')
  itIsATransformation('first')
  itIsATransformation('invoke')
  itIsATransformation('join')
  itIsATransformation('last')
  itIsATransformation('length')
  itIsATransformation('map')
  itIsATransformation('mapBy')
  itIsATransformation('reduce')
  itIsATransformation('reject')
  itIsATransformation('rejectBy')
  itIsATransformation('reverse')
  itIsATransformation('setEach')
  itIsATransformation('slice')
  itIsATransformation('sort')
  itIsATransformation('take')
  itIsATransformation('toSentence')
  itIsATransformation('uniq')
  itIsATransformation('without')

  itAliases = (source,target)->
    describe "##{source}", ->
      it "aliases ##{source} to ##{target.to}", ->
        run ->
          expect(pipeline[source]).toEqual(pipeline[target.to])

  itAliases('getEach',     to: 'mapBy')
  itAliases('mapProperty', to: 'mapBy')
  itAliases('size',        to: 'length')

  describe '#finalize', ->

    beforeEach ->
      pipeline.set('dependentKey', 'foo')

    describe 'when called with no key', ->
      it 'raises an exception', ->
        run ->
          pipeline.set('dependentKey', null)
          expect(-> pipeline.finalize()).toThrow()

    describe 'when called with no transformations', ->
      beforeEach ->
        pipeline.set('transformations', [])

      it 'raises an exception', ->
        run ->
          expect(-> pipeline.finalize()).toThrow()

    describe 'otherwise', ->
      finalized = null

      beforeEach ->
        pipeline.mapBy('bar')
        finalized = pipeline.finalize()

      afterEach ->
        finalized = null

      it 'returns a computed property', ->
        expect(finalized instanceof Em.Descriptor).toBeTruthy()
