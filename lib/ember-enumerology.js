(function() {


}).call(this);

(function() {
  window.Enumerology = Em.Namespace.create({
    VERSION: '0.2.4',
    create: function(dependentKey) {
      return Enumerology.Pipeline.create({
        dependentKey: dependentKey
      });
    }
  });

}).call(this);

(function() {
  Enumerology.FilterMixin = Em.Mixin.create({
    initialValue: void 0,
    isReduce: false,
    isFilter: true,
    init: function() {
      this.set('initialValue', Em.A());
      return this._super();
    },
    apply: function(dependentKey, target) {
      var dependency, initialValue,
        _this = this;
      dependency = "" + dependentKey + (this.get('dependencies'));
      initialValue = this.get('initialValue');
      this.set('targetKey', dependentKey);
      return Em.arrayComputed(dependency, {
        initialValue: initialValue,
        initialize: function(initialValue, changeMeta, instanceMeta) {
          return changeMeta.binding = target;
        },
        addedItem: function(accumulator, item, changeMeta, instanceMeta) {
          return _this.addedItem.call(_this, accumulator, item, changeMeta);
        },
        removedItem: function(accumulator, item, changeMeta, instanceMeta) {
          return _this.removedItem.call(_this, accumulator, item, changeMeta);
        }
      });
    }
  });

}).call(this);

(function() {
  var addTransformation, assert, classify, compare, lexigraphicCompare, numericCompare, pipeline,
    __slice = [].slice;

  classify = function(name) {
    return name.charAt(0).toUpperCase() + name.slice(1);
  };

  assert = function(msg, test) {
    if (!test) {
      throw new Error(msg);
    }
  };

  lexigraphicCompare = function(a, b) {
    return compare(a.toString(), b.toString());
  };

  numericCompare = function(a, b) {
    return compare(Number(a), Number(b));
  };

  compare = function(a, b) {
    if (a > b) {
      return 1;
    } else if (a < b) {
      return -1;
    } else {
      return 0;
    }
  };

  addTransformation = function(name, opts) {
    var newTransform;
    if (opts == null) {
      opts = {};
    }
    newTransform = Enumerology.Transform[classify(name)].create(opts);
    newTransform.set('pipepine', this);
    if (this.get("transformations.length") > 0) {
      assert("Cannot add any further operations after a reduce operation", this.get('transformations.lastObject.isFilter'));
    }
    this.get('transformations').addObject(newTransform);
    return this;
  };

  pipeline = Em.Object.extend({
    init: function() {
      this._super();
      this['getEach'] = this['mapBy'];
      this['mapProperty'] = this['mapBy'];
      this['isEmpty'] = this['empty'];
      this['isEmptyBy'] = this['emptyBy'];
      this['size'] = this['length'];
      return this.set('transformations', Em.A());
    },
    finalize: function() {
      var baseKey, dependentKeys, lastTransformation, transformations;
      baseKey = this.get('dependentKey');
      assert("Must have a dependent key", !Em.isEmpty(baseKey));
      transformations = this.get('transformations');
      assert("Must have at least one transformation applied", transformations.get('length') > 0);
      lastTransformation = transformations.get('lastObject');
      dependentKeys = transformations.map(function(item) {
        var dependencies;
        dependencies = item.get('dependencies');
        if (!Em.isEmpty(dependencies)) {
          return "" + baseKey + dependencies;
        }
      }).compact().uniq();
      return Em.computed.apply(Em, __slice.call(dependentKeys).concat([function() {
        var key, metaProperties, target;
        key = "_target." + baseKey;
        target = this;
        metaProperties = Em.Object.create();
        metaProperties.set('_target', target);
        transformations.forEach(function(transform, i) {
          var computed;
          computed = transform.apply(key, target);
          key = "_transform_" + i + "_result";
          return Em.defineProperty(metaProperties, key, computed);
        });
        return metaProperties.getWithDefault(key, lastTransformation.get('initialValue'));
      }]));
    },
    any: function(callback) {
      return addTransformation.call(this, 'any', {
        callback: callback
      });
    },
    anyBy: function(key, value) {
      if (value == null) {
        value = null;
      }
      return addTransformation.call(this, 'anyBy', {
        key: key,
        value: value
      });
    },
    compact: function() {
      return addTransformation.call(this, 'compact', {});
    },
    compactBy: function(key) {
      return addTransformation.call(this, 'compactBy', {
        key: key
      });
    },
    contains: function(obj) {
      return addTransformation.call(this, 'contains', {
        obj: obj
      });
    },
    empty: function() {
      return addTransformation.call(this, 'empty');
    },
    emptyBy: function(key) {
      return addTransformation.call(this, 'emptyBy', {
        key: key
      });
    },
    every: function(callback, target) {
      if (target == null) {
        target = null;
      }
      return addTransformation.call(this, 'every', {
        callback: callback,
        target: target
      });
    },
    everyBy: function(key, value) {
      if (value == null) {
        value = null;
      }
      return addTransformation.call(this, 'everyBy', {
        key: key,
        value: value
      });
    },
    filter: function(callback, target) {
      if (target == null) {
        target = null;
      }
      return addTransformation.call(this, 'filter', {
        callback: callback,
        target: target
      });
    },
    filterBy: function(key, value) {
      if (value == null) {
        value = null;
      }
      return addTransformation.call(this, 'filterBy', {
        key: key,
        value: value
      });
    },
    find: function(callback, target) {
      if (target == null) {
        target = null;
      }
      return addTransformation.call(this, 'find', {
        callback: callback,
        target: target
      });
    },
    findBy: function(key, value) {
      if (value == null) {
        value = null;
      }
      return addTransformation.call(this, 'findBy', {
        key: key,
        value: value
      });
    },
    first: function() {
      return addTransformation.call(this, 'first');
    },
    invoke: function() {
      var args, methodName;
      methodName = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return addTransformation.call(this, 'invoke', {
        methodName: methodName,
        args: args
      });
    },
    join: function(separator) {
      if (separator == null) {
        separator = ' ';
      }
      return addTransformation.call(this, 'join', {
        separator: separator
      });
    },
    last: function() {
      return addTransformation.call(this, 'last');
    },
    length: function() {
      return addTransformation.call(this, 'length');
    },
    map: function(callback, target) {
      if (target == null) {
        target = null;
      }
      return addTransformation.call(this, 'map', {
        callback: callback,
        target: target
      });
    },
    mapBy: function(key) {
      return addTransformation.call(this, 'mapBy', {
        key: key
      });
    },
    nonEmpty: function() {
      return addTransformation.call(this, 'nonEmpty');
    },
    nonEmptyBy: function(key) {
      return addTransformation.call(this, 'nonEmptyBy', {
        key: key
      });
    },
    reduce: function(callback, initialValue) {
      return addTransformation.call(this, 'reduce', {
        callback: callback,
        initialValue: initialValue
      });
    },
    reject: function(callback, target) {
      if (target == null) {
        target = null;
      }
      return addTransformation.call(this, 'reject', {
        callback: callback,
        target: target
      });
    },
    rejectBy: function(key, value) {
      if (value == null) {
        value = null;
      }
      return addTransformation.call(this, 'rejectBy', {
        key: key,
        value: value
      });
    },
    reverse: function() {
      return addTransformation.call(this, 'reverse');
    },
    setEach: function(key, value) {
      return addTransformation.call(this, 'setEach', {
        key: key,
        value: value
      });
    },
    slice: function(begin, end) {
      if (end == null) {
        end = null;
      }
      return addTransformation.call(this, 'slice', {
        begin: begin,
        end: end
      });
    },
    sort: function(compareFunction) {
      if (compareFunction == null) {
        compareFunction = void 0;
      }
      return addTransformation.call(this, 'sort', {
        compareFunction: compareFunction
      });
    },
    sortBy: function(key, compareFunction) {
      if (compareFunction == null) {
        compareFunction = void 0;
      }
      if (Em.isEmpty(compareFunction)) {
        compareFunction = lexigraphicCompare;
      }
      return addTransformation.call(this, 'sortBy', {
        key: key,
        compareFunction: compareFunction
      });
    },
    sortNumerically: function() {
      return addTransformation.call(this, 'sort', {
        compareFunction: numericCompare
      });
    },
    sortNumericallyBy: function(key) {
      return addTransformation.call(this, 'sortBy', {
        key: key,
        compareFunction: numericCompare
      });
    },
    take: function(howMany) {
      return addTransformation.call(this, 'take', {
        howMany: howMany
      });
    },
    toSentence: function(conjunction, oxfordComma) {
      if (conjunction == null) {
        conjunction = 'and';
      }
      if (oxfordComma == null) {
        oxfordComma = false;
      }
      return addTransformation.call(this, 'toSentence', {
        conjunction: conjunction,
        oxfordComma: oxfordComma
      });
    },
    uniq: function() {
      return addTransformation.call(this, 'uniq');
    },
    without: function(value) {
      return addTransformation.call(this, 'without', {
        value: value
      });
    }
  });

  Enumerology.Pipeline = pipeline;

}).call(this);

(function() {
  Enumerology.ReduceMixin = Em.Mixin.create({
    initialValue: void 0,
    isReduce: true,
    isFilter: false
  });

}).call(this);

(function() {
  Enumerology.Transform = Em.Object.extend({
    dependencies: '.[]',
    initialValue: null
  });

}).call(this);

(function() {
  Enumerology.TransformBy = Enumerology.Transform.extend({
    dependencies: (function() {
      return ".@each." + (this.get('key'));
    }).property('key')
  });

}).call(this);

(function() {
  var any;

  any = Enumerology.Transform.extend(Enumerology.ReduceMixin, {
    trueCount: 0,
    value: Ember.computed.gt('trueCount', 0),
    initialValue: false,
    apply: function(target, dependentKey) {
      var _this = this;
      return Em.reduceComputed("" + dependentKey + (this.get('dependencies')), {
        initialValue: this.get('initialValue'),
        addedItem: function(accumulatedValue, item, context) {
          var callback;
          callback = _this.get('callback');
          if (callback.call(context.binding, item)) {
            _this.incrementProperty('trueCount');
          }
          return _this.get('value');
        },
        removedItem: function(accumulatedValue, item, context) {
          var callback;
          callback = _this.get('callback');
          if (callback.call(context.binding, item)) {
            _this.decrementProperty('trueCount');
          }
          return _this.get('value');
        }
      });
    }
  });

  Enumerology.Transform.Any = any;

}).call(this);

(function() {
  var anyBy;

  anyBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.anyBy(this.get('key'), this.get('value'));
    }
  });

  Enumerology.Transform.AnyBy = anyBy;

}).call(this);

(function() {
  var compact;

  compact = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.compact();
    }
  });

  Enumerology.Transform.Compact = compact;

}).call(this);

(function() {
  var compactBy;

  compactBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.map(function(i) {
        return Em.isEmpty(i.get(this.get('key')));
      }).compact();
    }
  });

  Enumerology.Transform.CompactBy = compactBy;

}).call(this);

(function() {
  var contains;

  contains = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.contains(this.get('obj'));
    }
  });

  Enumerology.Transform.Contains = contains;

}).call(this);

(function() {
  var empty;

  empty = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.get('length') === 0;
    }
  });

  Enumerology.Transform.Empty = empty;

}).call(this);

(function() {
  var emptyBy;

  emptyBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.mapBy(this.get('key')).compact().get('length') === 0;
    }
  });

  Enumerology.Transform.EmptyBy = emptyBy;

}).call(this);

(function() {
  var every;

  every = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.every(this.get('callback'), this.getWithDefault('target', target));
    }
  });

  Enumerology.Transform.Every = every;

}).call(this);

(function() {
  var everyBy;

  everyBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.everyBy(this.get('key'), this.get('value'));
    }
  });

  Enumerology.Transform.EveryBy = everyBy;

}).call(this);

(function() {
  var filter;

  filter = Enumerology.Transform.extend(Enumerology.FilterMixin, {
    subArray: void 0,
    init: function() {
      this.set('subArray', new Ember.SubArray());
      return this._super();
    },
    addedItem: function(array, item, context) {
      var callback, filterIndex, match;
      callback = this.get('callback');
      match = !!callback.call(context.binding, item);
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (match) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex;
      console.log("" + (this.get('targetKey')) + " removedItem: ", array, item, context);
      filterIndex = this.get('subArray').removeItem(context.index);
      console.log("Removing at " + filterIndex);
      console.log("modifying array: ", array);
      if (filterIndex > -1) {
        array.removeAt(filterIndex);
      }
      console.log("resulting array: ", array);
      return array;
    }
  });

  Enumerology.Transform.Filter = filter;

}).call(this);

(function() {
  var filterBy;

  filterBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.filterBy(this.get('key'), this.get('value'));
    }
  });

  Enumerology.Transform.FilterBy = filterBy;

}).call(this);

(function() {
  var find;

  find = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.find(this.get('callback'), this.getWithDefault('target', target));
    }
  });

  Enumerology.Transform.Find = find;

}).call(this);

(function() {
  var findBy;

  findBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.findBy(this.get('key'), this.get('value'));
    }
  });

  Enumerology.Transform.FindBy = findBy;

}).call(this);

(function() {
  var first;

  first = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.get('firstObject');
    }
  });

  Enumerology.Transform.First = first;

}).call(this);

(function() {
  var invoke,
    __slice = [].slice;

  invoke = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.invoke.apply(collection, [this.get('methodName')].concat(__slice.call(this.getWithDefault('args', []))));
    }
  });

  Enumerology.Transform.Invoke = invoke;

}).call(this);

(function() {
  var join;

  join = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.join(this.get('separator'));
    }
  });

  Enumerology.Transform.Join = join;

}).call(this);

(function() {
  var last;

  last = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.get('lastObject');
    }
  });

  Enumerology.Transform.Last = last;

}).call(this);

(function() {
  var length;

  length = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.get('length');
    }
  });

  Enumerology.Transform.Length = length;

}).call(this);

(function() {
  var map;

  map = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.map(this.get('callback'), this.getWithDefault('target', target));
    }
  });

  Enumerology.Transform.Map = map;

}).call(this);

(function() {
  var mapBy;

  mapBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.mapBy(this.get('key'));
    }
  });

  Enumerology.Transform.MapBy = mapBy;

}).call(this);

(function() {
  var nonEmpty;

  nonEmpty = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.get('length') > 0;
    }
  });

  Enumerology.Transform.NonEmpty = nonEmpty;

}).call(this);

(function() {
  var nonEmptyBy;

  nonEmptyBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.mapBy(this.get('key')).compact().get('length') > 0;
    }
  });

  Enumerology.Transform.NonEmptyBy = nonEmptyBy;

}).call(this);

(function() {
  var reduce;

  reduce = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.reduce(this.get('callback'), this.get('initialValue'));
    }
  });

  Enumerology.Transform.Reduce = reduce;

}).call(this);

(function() {
  var reject;

  reject = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.reject(this.get('callback'), this.getWithDefault('target', target));
    }
  });

  Enumerology.Transform.Reject = reject;

}).call(this);

(function() {
  var rejectBy;

  rejectBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      return collection.rejectBy(this.get('key'), this.get('value'));
    }
  });

  Enumerology.Transform.RejectBy = rejectBy;

}).call(this);

(function() {
  var reverse;

  reverse = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.slice(0).reverse();
    }
  });

  Enumerology.Transform.Reverse = reverse;

}).call(this);

(function() {
  var setEach;

  setEach = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      collection.setEach(this.get('key'), this.get('value'));
      return collection;
    }
  });

  Enumerology.Transform.SetEach = setEach;

}).call(this);

(function() {
  var slice;

  slice = Enumerology.Transform.extend({
    apply: function(target, collection) {
      var begin, end;
      begin = this.get('begin');
      end = this.get('end');
      if (Em.isEmpty(end)) {
        return collection.slice(begin);
      } else {
        return collection.slice(begin, end);
      }
    }
  });

  Enumerology.Transform.Slice = slice;

}).call(this);

(function() {
  var sort;

  sort = Enumerology.Transform.extend({
    apply: function(target, collection) {
      var compareFunction;
      compareFunction = this.get('compareFunction');
      if (Em.isEmpty(compareFunction)) {
        return collection.slice(0).sort();
      } else {
        return collection.slice(0).sort(this.get('compareFunction'));
      }
    }
  });

  Enumerology.Transform.Sort = sort;

}).call(this);

(function() {
  var sortBy;

  sortBy = Enumerology.TransformBy.extend({
    apply: function(target, collection) {
      var compareFunction, key;
      compareFunction = this.get('compareFunction');
      key = this.get('key');
      return collection.slice(0).sort(function(a, b) {
        return compareFunction(a.get(key), b.get(key));
      });
    }
  });

  Enumerology.Transform.SortBy = sortBy;

}).call(this);

(function() {
  var take;

  take = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.slice(0, this.get('howMany'));
    }
  });

  Enumerology.Transform.Take = take;

}).call(this);

(function() {
  var toSentence;

  toSentence = Enumerology.Transform.extend({
    apply: function(target, collection) {
      var conjunction, last, list, oxfordComma;
      list = collection.slice(0, -1);
      last = collection.slice(-1);
      conjunction = this.get('conjunction');
      oxfordComma = this.get('oxfordComma') ? ',' : '';
      return "" + (list.join(', ')) + oxfordComma + " " + conjunction + " " + last;
    }
  });

  Enumerology.Transform.ToSentence = toSentence;

}).call(this);

(function() {
  var uniq;

  uniq = Enumerology.Transform.extend({
    apply: function(target, collection) {
      return collection.uniq(this.get('value'));
    }
  });

  Enumerology.Transform.Uniq = uniq;

}).call(this);

(function() {
  var without;

  without = Enumerology.Transform.extend();

  Enumerology.Transform.Without = without;

}).call(this);
