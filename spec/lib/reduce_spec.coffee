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
      expect(Em.get(Enumerology.Reduce, 'isReduce')).toBe(true)

  describe '#isFilter', ->
    it 'is false', ->
      expect(Em.get(Enumerology.Reduce, 'isFilter')).toBe(false)
