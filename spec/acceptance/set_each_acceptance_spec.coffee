run = Em.run
objectWithName = -> Em.Object.create(name: 'Biff')

describe 'Acceptance', ->
  describe 'setEach', ->
    object = undefined

    beforeEach ->
      run ->
        object = Em.Object.createWithMixins
          collection: Em.A()
          property:   Enumerology.create('collection').setEach('name', 'Marty McFly').finalize()

    describe 'when the dependent array is empty', ->
      it 'is empty', ->
        expect(object.get('property')).toEqual(Em.A())

    describe 'when an object with a name is added to the array', ->
      beforeEach ->
        run ->
          object.get('collection').pushObject(objectWithName())

      it 'changes the name', ->
        expect(object.get('property.firstObject.name')).toEqual('Marty McFly')
