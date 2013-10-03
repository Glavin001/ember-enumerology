run = Em.run

describe 'Enumerology.Reduce', ->
  object = undefined

  beforeEach ->
    run ->
      object = Enumerology.Reduce.create()

  it 'exists', ->
    expect(Enumerology.Reduce).toBeDefined()

  describe '#isReduce', ->
    it 'is true', ->
      expect(object.get('isReduce')).toBe(true)

  describe '#isFilter', ->
    it 'is false', ->
      expect(object.get('isFilter')).toBe(false)
