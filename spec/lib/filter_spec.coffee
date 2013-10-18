run = Em.run

describe 'Enumerology.Filter', ->
  object = undefined

  beforeEach ->
    run ->
      object = Enumerology.Filter.create()

  it 'exists', ->
    expect(Enumerology.Filter).toBeDefined()

  describe '#initialValue', ->
    it 'is an empty array', ->
      expect(object.get('initialValue')).toEqual(Em.A())

  describe '#isReduce', ->
    it 'is false', ->
      expect(Em.get(Enumerology.Filter, 'isReduce')).toBe(false)

  describe '#isFilter', ->
    it 'is true', ->
      expect(Em.get(Enumerology.Filter, 'isFilter')).toBe(true)
