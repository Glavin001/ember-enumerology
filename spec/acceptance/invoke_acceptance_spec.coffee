run = Em.run
describe 'Acceptance', ->
  describe 'invoke', ->

    object          = undefined
    invocationCount = undefined
    invocationArgs  = undefined
    invocable       = ->
      Em.Object.createWithMixins
        myAwesomeMethod: (args...)->
          invocationArgs = args
          invocationCount++

    beforeEach ->
      run ->
        invocationCount = 0
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').invoke('myAwesomeMethod', 'my', 'awesome', 'arguments').finalize()

    describe 'when the dependent array is empty', ->
      it 'is never invoked', ->
        object.get('property')
        expect(invocationCount).toEqual(0)

    describe 'when an object is added to the collection', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(invocable())

      it 'is invoked once', ->
        object.get('property')
        expect(invocationCount).toEqual(1)

      it 'is invoked with the correct arguments', ->
        object.get('property')
        expect(invocationArgs).toEqual(['my', 'awesome', 'arguments'])

    describe 'when multiple objects are added to the collection', ->
      times = 3
      beforeEach ->
        run ->
          [0..times-1].forEach (i)->
            object.get('collection').pushObject(invocable())

      it 'is invoked the correct number of times', ->
        object.get('property')
        expect(invocationCount).toEqual(times)
