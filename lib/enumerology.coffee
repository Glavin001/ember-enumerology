window.Enumerology = Em.Namespace.create
  VERSION: '0.2.1'

  create: (dependentKey)->
    Enumerology.Pipeline.create(dependentKey: dependentKey)
