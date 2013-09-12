run = Ember.run

describe 'Enumerology', ->

  it 'exists', ->
    expect(Enumerology).toBeDefined()

  it 'is the correct version', ->
    expect(Enumerology.VERSION).toEqual('0.2.4')

  describe '#create', ->
    key = -> 'foo'

    pipeline = -> Enumerology.create(key())

    it 'creates a pipeline', ->
      run ->
        expect(pipeline().constructor).toEqual(Enumerology.Pipeline)

    it 'sets the dependent key', ->
      run ->
        expect(pipeline().get('dependentKey')).toEqual(key())

