describe 'Enumerology.Reduce', ->
  it 'exists', ->
    expect(Enumerology.Reduce).toBeDefined()

  describe '#isReduce', ->
    it 'is true', ->
      expect(Em.Object.createWithMixins(Enumerology.Reduce).get('isReduce')).toBe(true)

  describe '#isFilter', ->
    it 'is false', ->
      expect(Em.Object.createWithMixins(Enumerology.Reduce).get('isFilter')).toBe(false)
