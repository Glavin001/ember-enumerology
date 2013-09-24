describe 'Enumerology.Filter', ->
  it 'exists', ->
    expect(Enumerology.Filter).toBeDefined()

  describe '#initialValue', ->
    expect(Em.Object.createWithMixins(Enumerology.Filter).get('initialValue')).toEqual([])

  describe '#isReduce', ->
    it 'is true', ->
      expect(Em.Object.createWithMixins(Enumerology.Filter).get('isReduce')).toBe(false)

  describe '#isFilter', ->
    it 'is false', ->
      expect(Em.Object.createWithMixins(Enumerology.Filter).get('isFilter')).toBe(true)
