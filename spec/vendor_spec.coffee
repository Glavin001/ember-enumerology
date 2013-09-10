describe 'Vendored libraries', ->

  describe 'Ember.VERSION', ->
    it 'is the correct version', ->
      expect(Ember.VERSION).toEqual('1.0.0')

  describe 'Handlebars.VERSION', ->
    it 'is the correct verstion', ->
      expect(Handlebars.VERSION).toEqual('1.0.0')
