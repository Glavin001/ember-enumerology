Enumerology.TransformBy = Enumerology.Transform.extend
  dependencies: (-> ".@each.#{@get('key')}" ).property('key')
