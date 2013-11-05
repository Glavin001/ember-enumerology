window.Enumerology = Em.Namespace.create
  VERSION: '0.3.1'

  create: (dependentKey)->
    Enumerology.Pipeline.create(dependentKey: dependentKey)
