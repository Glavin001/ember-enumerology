describe 'Enumerology.FilterMixin', ->
  it 'exists', ->
    expect(Enumerology.FilterMixin).toBeDefined()

  describe '#initialValue', ->
    expect(Em.Object.createWithMixins(Enumerology.FilterMixin).get('initialValue')).toEqual([])

  describe '#isReduce', ->
    it 'is true', ->
      expect(Em.Object.createWithMixins(Enumerology.FilterMixin).get('isReduce')).toBe(false)

  describe '#isFilter', ->
    it 'is false', ->
      expect(Em.Object.createWithMixins(Enumerology.FilterMixin).get('isFilter')).toBe(true)
