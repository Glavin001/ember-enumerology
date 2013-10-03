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
    it 'is true', ->
      expect(object.get('isReduce')).toBe(false)

  describe '#isFilter', ->
    it 'is false', ->
      expect(object.get('isFilter')).toBe(true)
