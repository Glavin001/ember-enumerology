run = Em.run
describe 'Acceptance', ->
  describe 'join', ->

    object          = undefined
    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection:        Em.A()
          joinedWithPipe:    Enumerology.create('collection').join('|').finalize()
          joinedWithDefault: Enumerology.create('collection').join().finalize()

    describe 'when the dependent array is empty', ->
      it 'is an empty string', ->
        expect(object.get('joinedWithPipe')).toEqual('')
        expect(object.get('joinedWithDefault')).toEqual('')

    describe 'when items are added', ->
      beforeEach ->
        run ->
          object.get('collection').pushObjects([1,'a',undefined, 'HELLO', null, 'pants'])

      it 'joins with the correct separator', ->
        expect(object.get('joinedWithPipe')).toEqual('1|a||HELLO||pants')
        expect(object.get('joinedWithDefault')).toEqual('1,a,,HELLO,,pants')
