/*! ember-enumerology - v0.3.0 - 2013-10-21
* https://github.com/jamesotron/ember-enumerology
* Copyright (c) 2013 James Harton; Licensed MIT */
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
  Enumerology.FilterBase = Em.Object.extend({
    initialValue: void 0,
    subArray: void 0,
    init: function() {
      this.set('initialValue', Em.A());
      this.set('subArray', new Ember.SubArray());
      return this._super();
    },
    apply: function(dependentKey, target) {
      var dependency,
        _this = this;
      dependency = "" + dependentKey + (this.get('dependencies'));
      this.set('dependentKey', dependentKey);
      return Em.arrayComputed(dependency, {
        initialValue: this.get('initialValue'),
        initialize: function(initialValue, changeMeta, instanceMeta) {
          changeMeta.binding = target;
          if (!Em.isEmpty(this.reset)) {
            return this.reset.call(this, initialValue, changeMeta, instanceMeta);
          }
        },
        addedItem: function(accumulator, item, changeMeta, instanceMeta) {
          return _this.addedItem.call(_this, accumulator, item, changeMeta);
        },
        removedItem: function(accumulator, item, changeMeta, instanceMeta) {
          return _this.removedItem.call(_this, accumulator, item, changeMeta);
        }
      });
    },
    removedItem: function(array, item, context) {
      var filterIndex;
      filterIndex = this.get('subArray').removeItem(context.index);
      if ((filterIndex > -1) && array.get('length') > filterIndex) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.FilterBase.reopenClass({
    isReduce: false,
    isFilter: Em.computed.not('isReduce')
  });

}).call(this);

(function() {
  var addTransformation, assert, classify, compare, lexigraphicCompare, numericCompare, pipeline, uniquePipline,
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
    opts['pipeline'] = this;
    newTransform = Enumerology.Transform[classify(name)].extend(opts);
    if (this.get("transformations.length") > 0) {
      assert("Cannot add any further operations after a reduce operation", this.get('transformations.lastObject.isFilter'));
    }
    this.get('transformations').addObject(newTransform);
    return this;
  };

  uniquePipline = function(meta, targetKey) {
    if (Em.isEmpty(meta['__enumerology__'])) {
      meta['__enumerology__'] = {};
    }
    if (Em.isEmpty(meta['__enumerology__'][targetKey])) {
      meta['__enumerology__'][targetKey] = Em.Object.create();
    }
    return meta['__enumerology__'][targetKey];
  };

  pipeline = Em.Object.extend({
    init: function() {
      this._super();
      this['getEach'] = this['mapBy'];
      this['mapProperty'] = this['mapBy'];
      this['isEmpty'] = this['empty'];
      this['isEmptyBy'] = this['emptyBy'];
      this['size'] = this['length'];
      this['tee'] = this['invoke'];
      this['some'] = this['nonEmpty'];
      this['someBy'] = this['nonEmptyBy'];
      return this.set('transformations', Em.A());
    },
    finalize: function() {
      var baseKey, firstDependentKey, transformations;
      baseKey = this.get('dependentKey');
      assert("Must have a dependent key", !Em.isEmpty(baseKey));
      transformations = this.get('transformations');
      assert("Must have at least one transformation applied", transformations.get('length') > 0);
      firstDependentKey = "" + baseKey + (transformations.get('firstObject').create().get('dependencies'));
      return Em.computed(firstDependentKey, function(targetKey) {
        var meta, target;
        target = this;
        meta = Em.meta(target);
        pipeline = uniquePipline(meta, targetKey);
        if (Em.isEmpty(pipeline.get('target'))) {
          pipeline.set('target', target);
          pipeline.set('lastKey', "target." + baseKey);
          transformations.forEach(function(transformClass, i) {
            var computed, transform;
            transform = transformClass.create();
            computed = transform.apply(pipeline.get('lastKey'), target);
            pipeline.set("transform_" + i, transform);
            pipeline.set("computed_" + i, computed);
            pipeline.set('lastKey', "result_" + i);
            return Em.defineProperty(pipeline, pipeline.get('lastKey'), computed);
          });
        }
        return pipeline.get(pipeline.get('lastKey'));
      });
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
        separator = void 0;
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
    skip: function(count) {
      return addTransformation.call(this, 'slice', {
        begin: count,
        end: void 0
      });
    },
    slice: function(begin, end) {
      if (end == null) {
        end = void 0;
      }
      return addTransformation.call(this, 'slice', {
        begin: begin,
        end: end
      });
    },
    sort: function(compareFunction) {
      if (compareFunction == null) {
        compareFunction = lexigraphicCompare;
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
      return addTransformation.call(this, 'slice', {
        begin: 0,
        end: howMany
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
  Enumerology.ReduceBase = Em.Object.extend({
    initialValue: void 0,
    matchCount: 0,
    apply: function(dependentKey, target) {
      var _this = this;
      this.set('dependentKey', dependentKey);
      return Em.reduceComputed(dependentKey, {
        initialValue: this.get('initialValue'),
        initialize: function(initialValue, changeMeta, instanceMeta) {
          changeMeta.binding = target;
          if (!Em.isEmpty(_this.reset)) {
            return _this.reset.call(_this, initialValue, changeMeta, instanceMeta);
          }
        },
        addedItem: function(accumulator, item, changeMeta, instanceMeta) {
          if (!Em.isEmpty(_this.addedItem)) {
            return _this.addedItem.call(_this, accumulator, item, changeMeta);
          }
        },
        removedItem: function(accumulator, item, changeMeta, instanceMeta) {
          if (!Em.isEmpty(_this.removedItem)) {
            return _this.removedItem.call(_this, accumulator, item, changeMeta);
          }
        }
      });
    }
  });

  Enumerology.ReduceBase.reopenClass({
    isReduce: true,
    isFilter: Em.computed.not('isReduce')
  });

}).call(this);

(function() {
  Enumerology.Transform = Em.Object.create();

}).call(this);

(function() {
  Enumerology.TransformByMixin = Em.Mixin.create({
    dependencies: (function() {
      return ".@each." + (this.get('key'));
    }).property('key')
  });

}).call(this);

(function() {
  Enumerology.TransformMixin = Em.Mixin.create({
    dependencies: '.[]',
    initialValue: null
  });

}).call(this);

(function() {
  Enumerology.Filter = Enumerology.FilterBase.extend(Enumerology.TransformMixin);

}).call(this);

(function() {
  Enumerology.FilterBy = Enumerology.FilterBase.extend(Enumerology.TransformByMixin);

}).call(this);

(function() {
  Enumerology.Reduce = Enumerology.ReduceBase.extend(Enumerology.TransformMixin);

}).call(this);

(function() {
  Enumerology.ReduceBy = Enumerology.ReduceBase.extend(Enumerology.TransformByMixin);

}).call(this);

(function() {
  var any;

  any = Enumerology.Reduce.extend({
    initialValue: false,
    matchCount: 0,
    addedItem: function(accumulatedValue, item, context) {
      var callback;
      callback = this.get('callback');
      if (callback.call(context.binding, item)) {
        this.incrementProperty('matchCount');
      }
      return this.get('matchCount') > 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      var callback;
      callback = this.get('callback');
      if (callback.call(context.binding, item)) {
        this.decrementProperty('matchCount');
      }
      return this.get('matchCount') > 0;
    }
  });

  Enumerology.Transform.Any = any;

}).call(this);

(function() {
  var anyBy;

  anyBy = Enumerology.ReduceBy.extend({
    initialValue: false,
    matchCount: 0,
    addedItem: function(accumulatedValue, item, context) {
      var key, value;
      key = this.get('key');
      value = this.get('value');
      if (item.get(key) === value) {
        this.incrementProperty('matchCount');
      }
      return this.get('matchCount') > 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      var key, value;
      key = this.get('key');
      value = this.get('value');
      if (item.get(key) === value) {
        this.decrementProperty('matchCount');
      }
      return this.get('matchCount') > 0;
    }
  });

  Enumerology.Transform.AnyBy = anyBy;

}).call(this);

(function() {
  var compact;

  compact = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      var filterIndex, match;
      match = item != null;
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (match) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex, match;
      match = item != null;
      filterIndex = this.get('subArray').removeItem(context.index, match);
      if (filterIndex > -1) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.Compact = compact;

}).call(this);

(function() {
  var compactBy;

  compactBy = Enumerology.FilterBy.extend({
    addedItem: function(array, item, context) {
      var filterIndex, key, match;
      key = this.get('key');
      match = item.get(key) != null;
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (match) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex, key, match;
      key = this.get('key');
      match = item.get(key) != null;
      filterIndex = this.get('subArray').removeItem(context.index, match);
      if (filterIndex > -1) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.CompactBy = compactBy;

}).call(this);

(function() {
  var contains;

  contains = Enumerology.Reduce.extend({
    initialValue: false,
    matchCount: 0,
    addedItem: function(accumulatedValue, item, context) {
      if (item === this.get('obj')) {
        this.incrementProperty('matchCount');
      }
      return this.get('matchCount') > 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      if (item === this.get('obj')) {
        this.decrementProperty('matchCount');
      }
      return this.get('matchCount') > 0;
    }
  });

  Enumerology.Transform.Contains = contains;

}).call(this);

(function() {
  var empty;

  empty = Enumerology.Reduce.extend({
    initialValue: true,
    matchCount: 0,
    addedItem: function(accumulatedValue, item, context) {
      this.incrementProperty('matchCount');
      return this.get('matchCount') === 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      this.decrementProperty('matchCount');
      return this.get('matchCount') === 0;
    }
  });

  Enumerology.Transform.Empty = empty;

}).call(this);

(function() {
  var emptyBy;

  emptyBy = Enumerology.ReduceBy.extend({
    initialValue: true,
    matchCount: 0,
    addedItem: function(accumulatedValue, item, context) {
      var key;
      key = this.get('key');
      if (item.get(key) != null) {
        this.incrementProperty('matchCount');
      }
      return this.get('matchCount') === 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      var key;
      key = this.get('key');
      if (item.get(key) != null) {
        this.decrementProperty('matchCount');
      }
      return this.get('matchCount') === 0;
    }
  });

  Enumerology.Transform.EmptyBy = emptyBy;

}).call(this);

(function() {
  var every;

  every = Enumerology.Reduce.extend({
    initialValue: true,
    matchCount: 0,
    totalElements: 0,
    reset: function() {
      return this.set('matchCount', 0);
    },
    addedItem: function(accumulatedValue, item, context) {
      var callback, match;
      callback = this.get('callback');
      match = !!callback.call(context.binding, item);
      this.incrementProperty('totalElements');
      if (match) {
        this.incrementProperty('matchCount');
      }
      return this.get('matchCount') === this.get('totalElements');
    },
    removedItem: function(accumulatedValue, item, context) {
      var callback, match;
      callback = this.get('callback');
      match = !!callback.call(context.binding, item);
      this.decrementProperty('totalElements');
      if (match) {
        this.decrementProperty('matchCount');
      }
      return this.get('matchCount') === this.get('totalElements');
    }
  });

  Enumerology.Transform.Every = every;

}).call(this);

(function() {
  var everyBy;

  everyBy = Enumerology.ReduceBy.extend({
    initialValue: true,
    matchCount: 0,
    totalElements: 0,
    addedItem: function(accumulatedValue, item, context) {
      var key, match, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) === value;
      this.incrementProperty('totalElements');
      if (match) {
        this.incrementProperty('matchCount');
      }
      return this.get('matchCount') === this.get('totalElements');
    },
    removedItem: function(accumulatedValue, item, context) {
      var key, match, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) === value;
      this.decrementProperty('totalElements');
      if (match) {
        this.decrementProperty('matchCount');
      }
      return this.get('matchCount') === this.get('totalElements');
    }
  });

  Enumerology.Transform.EveryBy = everyBy;

}).call(this);

(function() {
  var filter;

  filter = Enumerology.Filter.extend({
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
      filterIndex = this.get('subArray').removeItem(context.index);
      if ((filterIndex > -1) && array.get('length') > filterIndex) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.Filter = filter;

}).call(this);

(function() {
  var filterBy;

  filterBy = Enumerology.FilterBy.extend({
    addedItem: function(array, item, context) {
      var filterIndex, key, match, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) === value;
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (match) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex, key, match, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) === value;
      filterIndex = this.get('subArray').removeItem(context.index);
      if ((filterIndex > -1) && array.get('length') > filterIndex) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.FilterBy = filterBy;

}).call(this);

(function() {
  var find;

  find = Enumerology.Reduce.extend({
    initialValue: function() {
      return void 0;
    },
    init: function() {
      this.set('matches', Em.A());
      this.set('subArray', new Em.SubArray());
      return this._super();
    },
    addedItem: function(accumulatedValue, item, context) {
      var callback, filterIndex, match, matches, subArray;
      callback = this.get('callback');
      match = callback.call(context.binding, item);
      subArray = this.get('subArray');
      filterIndex = subArray.addItem(context.index, match);
      matches = this.get('matches');
      if (match) {
        matches.insertAt(filterIndex, item);
      }
      return matches.get('firstObject');
    },
    removedItem: function(accumulatedValue, item, context) {
      var callback, filterIndex, match, matches, subArray;
      callback = this.get('callback');
      match = callback.call(context.binding, item);
      subArray = this.get('subArray');
      filterIndex = subArray.removeItem(context.index);
      matches = this.get('matches');
      if ((filterIndex > -1) && matches.get('length') > filterIndex) {
        matches.removeAt(filterIndex);
      }
      return matches.get('firstObject');
    }
  });

  Enumerology.Transform.Find = find;

}).call(this);

(function() {
  var findBy;

  findBy = Enumerology.ReduceBy.extend({
    initialValue: function() {
      return void 0;
    },
    init: function() {
      this.set('matches', Em.A());
      this.set('subArray', new Em.SubArray());
      return this._super();
    },
    addedItem: function(accumulatedValue, item, context) {
      var filterIndex, key, match, matches, subArray, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) === value;
      subArray = this.get('subArray');
      filterIndex = subArray.addItem(context.index, match);
      matches = this.get('matches');
      if (match) {
        matches.insertAt(filterIndex, item);
      }
      return matches.get('firstObject');
    },
    removedItem: function(accumulatedValue, item, context) {
      var filterIndex, key, match, matches, subArray, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) === value;
      subArray = this.get('subArray');
      filterIndex = subArray.removeItem(context.index);
      matches = this.get('matches');
      if ((filterIndex > -1) && matches.get('length') > filterIndex) {
        matches.removeAt(filterIndex);
      }
      return matches.get('firstObject');
    }
  });

  Enumerology.Transform.FindBy = findBy;

}).call(this);

(function() {
  var first;

  first = Enumerology.Reduce.extend({
    initialValue: function() {
      return void 0;
    },
    init: function() {
      return this.set('content', Em.A());
    },
    addedItem: function(accumulatedValue, item, context) {
      var content;
      content = this.get('content');
      content.insertAt(context.index, item);
      return content.get('firstObject');
    },
    removedItem: function(accumulatedValue, item, context) {
      var content;
      content = this.get('content');
      content.removeAt(context.index);
      return content.get('firstObject');
    }
  });

  Enumerology.Transform.First = first;

}).call(this);

(function() {
  var invoke;

  invoke = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      var args, method, methodName;
      methodName = this.get('methodName');
      args = this.getWithDefault('args', []);
      method = item.get(methodName);
      method.apply(item, args);
      array.insertAt(context.index, item);
      return array;
    },
    removedItem: function(array, item, context) {
      array.removeAt(context.index);
      return array;
    }
  });

  Enumerology.Transform.Invoke = invoke;

}).call(this);

(function() {
  var join;

  join = Enumerology.Reduce.extend({
    initialValue: '',
    init: function() {
      return this.set('content', Em.A());
    },
    addedItem: function(accumulatedValue, item, context) {
      var content;
      content = this.get('content');
      content.insertAt(context.index, item);
      return content.join(this.get('separator'));
    },
    removedItem: function(accumulatedValue, item, context) {
      var content;
      content = this.get('content');
      content.removeAt(context.index);
      return content.join(this.get('separator'));
    }
  });

  Enumerology.Transform.Join = join;

}).call(this);

(function() {
  var last;

  last = Enumerology.Reduce.extend({
    initialValue: function() {
      return void 0;
    },
    init: function() {
      return this.set('content', Em.A());
    },
    addedItem: function(accumulatedValue, item, context) {
      var content;
      content = this.get('content');
      content.insertAt(context.index, item);
      return content.get('lastObject');
    },
    removedItem: function(accumulatedValue, item, context) {
      var content;
      content = this.get('content');
      content.removeAt(context.index);
      return content.get('lastObject');
    }
  });

  Enumerology.Transform.Last = last;

}).call(this);

(function() {
  var length;

  length = Enumerology.Reduce.extend({
    initialValue: 0,
    addedItem: function(accumulatedValue, item, context) {
      return ++accumulatedValue;
    },
    removedItem: function(accumulatedValue, item, context) {
      return --accumulatedValue;
    }
  });

  Enumerology.Transform.Length = length;

}).call(this);

(function() {
  var map;

  map = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      var callback, mappedValue;
      callback = this.get('callback');
      mappedValue = callback.call(context.binding, item);
      array.insertAt(context.index, mappedValue);
      return array;
    },
    removedItem: function(array, item, context) {
      array.removeAt(context.index);
      return array;
    }
  });

  Enumerology.Transform.Map = map;

}).call(this);

(function() {
  var mapBy;

  mapBy = Enumerology.FilterBy.extend({
    addedItem: function(array, item, context) {
      var key;
      key = this.get('key');
      array.insertAt(context.index, item.get(key));
      return array;
    },
    removedItem: function(array, item, context) {
      array.removeAt(context.index);
      return array;
    }
  });

  Enumerology.Transform.MapBy = mapBy;

}).call(this);

(function() {
  var nonEmpty;

  nonEmpty = Enumerology.Reduce.extend({
    initialValue: false,
    count: 0,
    addedItem: function(accumulatedValue, item, context) {
      this.incrementProperty('count');
      return this.get('count') > 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      this.decrementProperty('count');
      return this.get('count') > 0;
    }
  });

  Enumerology.Transform.NonEmpty = nonEmpty;

}).call(this);

(function() {
  var nonEmptyBy;

  nonEmptyBy = Enumerology.ReduceBy.extend({
    initialValue: false,
    count: 0,
    addedItem: function(accumulatedValue, item, context) {
      if (!Em.isEmpty(item.get(this.get('key')))) {
        this.incrementProperty('count');
      }
      return this.get('count') > 0;
    },
    removedItem: function(accumulatedValue, item, context) {
      if (!Em.isEmpty(item.get(this.get('key')))) {
        this.decrementProperty('count');
      }
      return this.get('count') > 0;
    }
  });

  Enumerology.Transform.NonEmptyBy = nonEmptyBy;

}).call(this);

(function() {
  var reduce;

  reduce = Enumerology.Reduce.extend({
    addedItem: function(accumulatedValue, item, context) {
      var callback;
      callback = this.get('callback');
      return callback.call(context.binding, accumulatedValue, item, context.index, context.arrayChanged);
    }
  });

  Enumerology.Transform.Reduce = reduce;

}).call(this);

(function() {
  var reject;

  reject = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      var callback, filterIndex, match;
      callback = this.get('callback');
      match = !callback.call(context.binding, item);
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (match) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex;
      filterIndex = this.get('subArray').removeItem(context.index);
      if ((filterIndex > -1) && array.get('length') > filterIndex) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.Reject = reject;

}).call(this);

(function() {
  var rejectBy;

  rejectBy = Enumerology.FilterBy.extend({
    addedItem: function(array, item, context) {
      var filterIndex, key, match, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) !== value;
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (match) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex, key, match, value;
      key = this.get('key');
      value = this.get('value');
      match = item.get(key) !== value;
      filterIndex = this.get('subArray').removeItem(context.index);
      if ((filterIndex > -1) && array.get('length') > filterIndex) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.RejectBy = rejectBy;

}).call(this);

(function() {
  var reverse;

  reverse = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      var newIndex;
      newIndex = array.get('length') - context.index;
      array.insertAt(newIndex, item);
      return array;
    },
    removedItem: function(array, item, context) {
      var newIndex;
      newIndex = array.get('length') - context.index;
      array.removeAt(newIndex - 1);
      return array;
    }
  });

  Enumerology.Transform.Reverse = reverse;

}).call(this);

(function() {
  var setEach;

  setEach = Enumerology.FilterBy.extend({
    addedItem: function(array, item, context) {
      var key, value;
      key = this.get('key');
      value = this.get('value');
      item.set(key, value);
      return context.arrayChanged;
    },
    removedItem: function(array, item, context) {
      return context.arrayChanged;
    }
  });

  Enumerology.Transform.SetEach = setEach;

}).call(this);

(function() {
  var slice;

  slice = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      return context.arrayChanged.slice(this.get('begin'), this.get('end'));
    },
    removedItem: function(array, item, context) {
      return context.arrayChanged.slice(this.get('begin'), this.get('end'));
    }
  });

  Enumerology.Transform.Slice = slice;

}).call(this);

(function() {
  var sort;

  sort = Enumerology.Filter.extend({
    init: function() {
      this._super();
      return this.set('positionStore', {});
    },
    addedItem: function(array, item, context) {
      var c, compareFunction, doCompare, i, positionStore, _i, _ref;
      compareFunction = this.get('compareFunction');
      doCompare = function(itemA, itemB) {
        return compareFunction.call(context.binding, itemA, itemB);
      };
      positionStore = this.get('positionStore');
      if (array.get('length') === 0) {
        positionStore[context.index] = 0;
        array.insertAt(0, item);
        return array;
      } else {
        for (i = _i = 0, _ref = array.get('length') - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          c = doCompare(item, array.objectAt(i));
          if (c === -1) {
            positionStore[context.index] = i;
            array.insertAt(i, item);
            return array;
          }
          if (c === 0) {
            positionStore[context.index] = i + 1;
            array.insertAt(i + 1, item);
            return array;
          }
        }
        positionStore[context.index] = array.get('length');
        return array.insertAt(array.get('length'), item);
      }
    },
    removedItem: function(array, item, context) {
      var positionStore;
      positionStore = this.get('positionStore');
      array.removeAt(positionStore[context.index]);
      delete positionStore[context.index];
      return array;
    }
  });

  Enumerology.Transform.Sort = sort;

}).call(this);

(function() {
  var sortBy;

  sortBy = Enumerology.FilterBy.extend({
    init: function() {
      this._super();
      return this.set('positionStore', {});
    },
    addedItem: function(array, item, context) {
      var c, compareFunction, doCompare, i, key, positionStore, _i, _ref;
      compareFunction = this.get('compareFunction');
      key = this.get('key');
      doCompare = function(itemA, itemB) {
        return compareFunction.call(context.binding, itemA, itemB);
      };
      positionStore = this.get('positionStore');
      if (array.get('length') === 0) {
        positionStore[context.index] = 0;
        array.insertAt(0, item);
        return array;
      } else {
        for (i = _i = 0, _ref = array.get('length') - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          c = doCompare(item.get(key), array.objectAt(i).get(key));
          if (c === -1) {
            positionStore[context.index] = i;
            array.insertAt(i, item);
            return array;
          }
          if (c === 0) {
            positionStore[context.index] = i + 1;
            array.insertAt(i + 1, item);
            return array;
          }
        }
        positionStore[context.index] = array.get('length');
        return array.insertAt(array.get('length'), item);
      }
    },
    removedItem: function(array, item, context) {
      var positionStore;
      positionStore = this.get('positionStore');
      array.removeAt(positionStore[context.index]);
      delete positionStore[context.index];
      return array;
    }
  });

  Enumerology.Transform.SortBy = sortBy;

}).call(this);

(function() {
  var toSentence;

  toSentence = Enumerology.Reduce.extend({
    initialValue: '',
    addedItem: function(accumulatedValue, item, context) {
      var collection, conjunction, last, list, oxfordComma;
      collection = context.arrayChanged;
      list = collection.slice(0, -1);
      last = collection.slice(-1);
      conjunction = this.get('conjunction');
      oxfordComma = this.get('oxfordComma') ? ',' : '';
      return "" + (list.join(', ')) + oxfordComma + " " + conjunction + " " + last;
    },
    removedItem: function(accumulatedValue, item, context) {
      var collection, conjunction, last, list, oxfordComma;
      collection = context.arrayChanged;
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

  uniq = Enumerology.Filter.extend({
    addedItem: function(array, item, context) {
      var filterIndex, match;
      match = (array.get('length') === 0) || !(array.any(function(i) {
        return i === item;
      }));
      filterIndex = this.get('subArray').addItem(context.index, match);
      if (filterIndex >= 0) {
        array.insertAt(filterIndex, item);
      }
      return array;
    },
    removedItem: function(array, item, context) {
      var filterIndex;
      filterIndex = this.get('subArray').removeItem(context.index);
      if (filterIndex >= 0) {
        array.removeAt(filterIndex);
      }
      return array;
    }
  });

  Enumerology.Transform.Uniq = uniq;

}).call(this);

(function() {
  var without;

  without = Enumerology.Filter.extend();

  Enumerology.Transform.Without = without;

}).call(this);
