window.Enumerology = Em.Namespace.create
  VERSION: '0.10.0'

  create: (dependentKey)->
    Enumerology.Pipeline.create(dependentKey: dependentKey)
