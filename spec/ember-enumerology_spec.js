(function() {
  var run;

  run = Em.run;

  describe('Acceptance', function() {
    return describe('any', function() {
      var callbackCalls, object;
      object = void 0;
      callbackCalls = void 0;
      beforeEach(function() {
        return run(function() {
          callbackCalls = 0;
          object = Em.Object.extend({
            collection: [],
            property: Enumerology.create('collection').any(function(i) {
              ++callbackCalls;
              return i === 'a';
            }).finalize()
          }).create();
          return object.get('property');
        });
      });
      describe('when the dependent key is an empty array', function() {
        return it('is false', function() {
          return expect(object.get('property')).toBe(false);
        });
      });
      describe('when a non-matching item is added', function() {
        beforeEach(function() {
          return run(function() {
            return object.get('collection').pushObject('b');
          });
        });
        return it('is false', function() {
          return expect(object.get('property')).toBe(false);
        });
      });
      describe('when a matching item is added', function() {
        beforeEach(function() {
          return run(function() {
            return object.get('collection').pushObject('a');
          });
        });
        return it('is true', function() {
          return expect(object.get('property')).toBe(true);
        });
      });
      return describe('when the dependent key contains matching and non-matching values', function() {
        beforeEach(function() {
          return run(function() {
            object.get('collection').pushObjects(['a', 'a', 'b', 'b']);
            return expect(callbackCalls).toEqual(4, "Callback invoked expected number of times");
          });
        });
        describe('when the penultimate matching item is removed', function() {
          beforeEach(function() {
            return run(function() {
              return object.get('collection').removeAt(0, 1);
            });
          });
          return it('is true', function() {
            return expect(object.get('property')).toBe(true);
          });
        });
        describe('when the last matching item is removed', function() {
          beforeEach(function() {
            return run(function() {
              object.get('collection').removeAt(0, 2);
              return expect(callbackCalls).toEqual(6, "Callback invoked expected number of times");
            });
          });
          return it('is false', function() {
            return expect(object.get('property')).toBe(false);
          });
        });
        return describe('when a non-matching item is removed', function() {
          beforeEach(function() {
            return run(function() {
              return object.get('collection').removeAt(2, 1);
            });
          });
          return it('is true', function() {
            return expect(object.get('property')).toBe(true);
          });
        });
      });
    });
  });

}).call(this);

(function() {
  var run;

  run = Em.run;

  describe('acceptance', function() {
    return describe('filter', function() {
      var object;
      object = void 0;
      beforeEach(function() {
        return run(function() {
          object = Em.Object.createWithMixins({
            collection: Em.A(),
            filteredCollection: Enumerology.create('collection').filter(function(item) {
              return item.toUpperCase() === item;
            }).finalize()
          });
          return object.get('filteredCollection');
        });
      });
      describe('when the dependent array is empty', function() {
        return it('has length zero', function() {
          return expect(object.get('filteredCollection.length')).toEqual(0);
        });
      });
      describe('when a matching item is appended to the dependent array', function() {
        beforeEach(function() {
          return run(function() {
            return object.get('collection').pushObject('A');
          });
        });
        return it('is appended to the array', function() {
          return expect(object.get('filteredCollection')).toEqual(['A']);
        });
      });
      describe('when a non-matching item is appended to the dependent array', function() {
        beforeEach(function() {
          return run(function() {
            return object.get('collection').pushObject('b');
          });
        });
        return it('is not appended to the array', function() {
          return expect(object.get('filteredCollection')).toEqual([]);
        });
      });
      describe('a matching item is inserted before existing matching items in the dependent array', function() {
        beforeEach(function() {
          return run(function() {
            object.get('collection').pushObjects(['a', 'A', 'b', 'B']);
            expect(object.get('filteredCollection')).toEqual(['A', 'B']);
            return object.get('collection').insertAt(2, 'C');
          });
        });
        return it('is inserted in the array, preserving order', function() {
          return expect(object.get('filteredCollection')).toEqual(['A', 'C', 'B']);
        });
      });
      return describe('when the dependent array contains matching and non-matching items', function() {
        beforeEach(function() {
          return run(function() {
            return object.get('collection').pushObjects(['a', 'A', 'B', 'A', 'b', 'B']);
          });
        });
        describe('when a non-matching item is removed', function() {
          beforeEach(function() {
            return run(function() {
              return object.get('collection').removeAt(4, 1);
            });
          });
          return it('remains unchanged', function() {
            return expect(object.get('filteredCollection')).toEqual(['A', 'B', 'A', 'B']);
          });
        });
        describe('when non-matching and matching items are removed', function() {
          beforeEach(function() {
            return run(function() {
              object.get('collection').removeAt(0, 1);
              return object.get('collection').removeAt(1, 1);
            });
          });
          return it('has the corresponding matching item removed', function() {
            return expect(object.get('filteredCollection')).toEqual(['A', 'A', 'B']);
          });
        });
        describe('when a matching item is removed', function() {
          beforeEach(function() {
            return run(function() {
              return object.get('collection').removeAt(2, 1);
            });
          });
          return it('has the corresponding matching item removed', function() {
            return expect(object.get('filteredCollection')).toEqual(['A', 'A', 'B']);
          });
        });
        return describe('when a duplicate matching item is removed', function() {
          beforeEach(function() {
            return run(function() {
              return object.get('collection').removeAt(5, 1);
            });
          });
          return it('has the corresponding matching item removed', function() {
            return expect(object.get('filteredCollection')).toEqual(['A', 'B', 'A']);
          });
        });
      });
    });
  });

}).call(this);

(function() {
  var run;

  run = Em.run;

  describe('Acceptance', function() {
    var castMember, itCalculatesCorrectly, object, objectWithComputed;
    object = null;
    beforeEach(function() {
      return object = null;
    });
    afterEach(function() {
      return object = null;
    });
    castMember = Em.Object.extend({
      nameLength: (function() {
        return this.get('name.length');
      }).property('name')
    });
    objectWithComputed = function(func) {
      return Em.Object.extend({
        characters: ['Marty', 'Doc', 'Jennifer', null],
        cast: [
          castMember.create({
            name: 'Michael J. Fox'
          }), castMember.create({
            name: 'Christopher Lloyd'
          }), castMember.create({
            name: 'Claudia Wells'
          })
        ],
        computed: func()
      }).create();
    };
    itCalculatesCorrectly = function(name, func, result) {
      return describe(name, function() {
        beforeEach(function() {
          return run(function() {
            return object = objectWithComputed(func);
          });
        });
        return it('calculates the correct result', function() {
          return run(function() {
            return expect(object.get('computed')).toEqual(result);
          });
        });
      });
    };
    return itCalculatesCorrectly('any', (function() {
      return Enumerology.create('characters').any(function(i) {
        return i === "Marty";
      }).finalize();
    }), true);
  });

}).call(this);

(function() {
  describe('Vendored libraries', function() {
    describe('Ember.VERSION', function() {
      return it('is the correct version', function() {
        return expect(Ember.VERSION).toEqual('1.0.0');
      });
    });
    return describe('Handlebars.VERSION', function() {
      return it('is the correct verstion', function() {
        return expect(Handlebars.VERSION).toEqual('1.0.0');
      });
    });
  });

}).call(this);

(function() {
  var run;

  run = Ember.run;

  describe('Enumerology', function() {
    it('exists', function() {
      return expect(Enumerology).toBeDefined();
    });
    it('is the correct version', function() {
      return expect(Enumerology.VERSION).toEqual('0.2.4');
    });
    return describe('#create', function() {
      var key, pipeline;
      key = function() {
        return 'foo';
      };
      pipeline = function() {
        return Enumerology.create(key());
      };
      it('creates a pipeline', function() {
        return run(function() {
          return expect(pipeline().constructor).toEqual(Enumerology.Pipeline);
        });
      });
      return it('sets the dependent key', function() {
        return run(function() {
          return expect(pipeline().get('dependentKey')).toEqual(key());
        });
      });
    });
  });

}).call(this);

(function() {
  var classify, run;

  run = Ember.run;

  classify = function(name) {
    return name.charAt(0).toUpperCase() + name.slice(1);
  };

}).call(this);

(function() {
  describe('Enumerology.Transform', function() {
    return it('exists', function() {
      return expect(Enumerology.Transform).toBeDefined();
    });
  });

}).call(this);

(function() {
  describe('Enumerology.Transform.Any', function() {
    return it('exists', function() {
      return expect(Enumerology.Transform.Any).toBeDefined();
    });
  });

}).call(this);
