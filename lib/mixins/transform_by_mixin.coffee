Enumerology.TransformByMixin = Em.Mixin.create
  dependencies: (-> ".@each.#{@get('key')}" ).property('key')
