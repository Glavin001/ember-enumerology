describe 'Enumerology.ReduceMixin', ->
  it 'exists', ->
    expect(Enumerology.ReduceMixin).toBeDefined()

  describe '#isReduce', ->
    it 'is true', ->
      expect(Em.Object.createWithMixins(Enumerology.ReduceMixin).get('isReduce')).toBe(true)

  describe '#isFilter', ->
    it 'is false', ->
      expect(Em.Object.createWithMixins(Enumerology.ReduceMixin).get('isFilter')).toBe(false)
