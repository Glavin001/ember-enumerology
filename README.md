# ember-enumerology

[![Build Status](https://travis-ci.org/jamesotron/ember-enumerology.png)](https://travis-ci.org/jamesotron/ember-enumerology)

Automagic creation of computed properties from enumerable chains.

## Getting Started

Enumerology is a bunch of useful Computed Property macros for working on enumerables.

Best I give you an example, eh?

```javascript
var Movie = Em.Object.extend({
      castNames: Enumerology.create('cast').mapBy('name').sort().finalize(),
      characterNames: Enumerology.create('cast').mapBy('character').sort().finalize()
    });

var bttf = Movie.create({
      cast: [
        Em.Object.create({name: 'Michael J. Fox', character: 'Marty McFly'}),
        Em.Object.create({name: 'Christopher Lloyd', character: 'Doc Emmett Brown'}),
        Em.Object.create({name: 'Claudia Wells', character: 'Jennifer Parker'}),
      ]
    });

bttf.get('castNames')      // => ["Christopher Lloyd", "Claudia Wells", "Michael J. Fox"]
bttf.get('characterNames') // => ["Doc Emmett Brown", "Jennifer Parker", "Marty McFly"]
```

### In the browser
Download the [production version][min] or the [development version][max].

[min]: https://raw.github.com/jamesotron/ember-enumerology/master/dist/ember-enumerology.min.js
[max]: https://raw.github.com/jamesotron/ember-enumerology/master/dist/ember-enumerology.js

In your web page:

```html
<script src="dist/ember-enumerology.min.js"></script>
```

### Creating Enumerologies

In order to create an Enumerology-created computed property you call `Enumerology.create` and pass as an argument the name of the collection property to depend on (the part you would stick in the `property()` call in a normal computed property)

You can then chain on as many transformations as you like (eg `map` or `uniq`) and then call `finalize()` on the end of the chain to create and return the computed property.

For example:

```javascript
Ember.Object.extend({
  fruit: ['apple', 'apple', 'banana', 'pear'],
  uniqueFruitCount: Enumerology.create('fruit').uniq().length().finalize()
})
```

### Enumeration transforms

Enumerology supports a bunch of methods, which it calls "transforms" that can be applied
to an enumerable.  Most can be chained, although it obviously makes no sense to try and
map the result of a method which returns an object, instead of an array (like `first`
or `any`).

#### `any`

see: [Ember.Enumerable#any](http://emberjs.com/api/classes/Ember.Enumerable.html#method_any)

#### `anyBy`

see: [Ember.Enumerable#anyBy](http://emberjs.com/api/classes/Ember.Enumerable.html#method_anyBy)

#### `compact`

see: [Ember.Enumerable#compact](http://emberjs.com/api/classes/Ember.Enumerable.html#method_compact)

#### `compactBy`

Removes any elements where a named property is empty, `null` or `undefined`.

##### Parameters

- `key` - The name of the property to use for emptiness test.

#### `contains`

see: [Ember.Enumerable#contains](http://emberjs.com/api/classes/Ember.Enumerable.html#method_contains)

#### `empty`

Returns true of the collection contains zero elements.

#### `every`

see: [Ember.Enumerable#every](http://emberjs.com/api/classes/Ember.Enumerable.html#method_every)

#### `everyBy`

see: [Ember.Enumerable#everyBy](http://emberjs.com/api/classes/Ember.Enumerable.html#method_everyBy)

#### `filter`

see: [Ember.Enumerable#filter](http://emberjs.com/api/classes/Ember.Enumerable.html#method_filter)

#### `filterBy`

see: [Ember.Enumerable#filterBy](http://emberjs.com/api/classes/Ember.Enumerable.html#method_filterBy)

#### `find`

see: [Ember.Enumerable#find](http://emberjs.com/api/classes/Ember.Enumerable.html#method_find)

#### `findBy`

see: [Ember.Enumerable#findBy](http://emberjs.com/api/classes/Ember.Enumerable.html#method_findBy)

#### `first`

Returns the first element of the collection.

#### `invoke`

see: [Ember.Enumerable#invoke](http://emberjs.com/api/classes/Ember.Enumerable.html#method_invoke)

#### `isEmpty`

alias for `empty`

#### `join`

Join a collection of strings with a given separator.

##### Parameters

- `separator` - A string to use as the separator for each element. Defaults to `' '`

#### `last`

Returns the last element of the collection.

#### `length`

Returns the number of elements in the collection.

#### `map`

see: [Ember.Enumerable#map](http://emberjs.com/api/classes/Ember.Enumerable.html#method_map)

#### `mapBy`

see: [Ember.Enumerable#mapBy](http://emberjs.com/api/classes/Ember.Enumerable.html#method_mapBy)

#### `nonEmpty`

Returns true of the collection has one or more elements in it.

#### `reduce`

see: [Ember.Enumerable#reduce](http://emberjs.com/api/classes/Ember.Enumerable.html#method_reduce)

#### `reject`

see: [Ember.Enumerable#reject](http://emberjs.com/api/classes/Ember.Enumerable.html#method_reject)

#### `rejectBy`

see: [Ember.Enumerable#rejectBy](http://emberjs.com/api/classes/Ember.Enumerable.html#method_rejectBy)

#### `reverse`

see: [Array#reverse](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reverse)

note: Enumerology never mutates the original collection, so a new copy of the array is created before being passed into `reverse`.

#### `setEach`

see: [Ember.Enumerable#setEach](http://emberjs.com/api/classes/Ember.Enumerable.html#method_setEach)

note: Ember's `setEach` method doesn't return the original collection, however Enumerology's does to enable chaining.

#### `slice`

see: [Array#slice](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice)

#### `sort`

see: [Array#sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)

notes:

  - Enumerology never mutates the original collection, so a new copy of the array is created before being passed into `sort`.
  - By default JavaScript sorts collections "lexigraphically", ie in alphabetical order (if no  `compareFunction` is provided).

see also: `sortNumerically`

### `sortBy`

Sorts a collection of objects by the value of a named property.

##### Parameters

- `key` - the property name to sort on.
- `compareFunction` - a function to define a custom sort operation. See: [Array#sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)

notes:

  - Enumerology never mutates the original collection, so a new copy of the array is created before being passed into `sortBy`.
  - By default JavaScript sorts collections "lexigraphically", ie in alphabetical order (if no `compareFunction` is provided).

see also: `sortNumericallyBy`

### `sortNumerically`

Sorts a collection of objects numerically (instead of lexigraphically, as JavaScript does by default).

see: [Array#sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)

### `sortNumericallyBy`

Sorts a collection of objects numerically by the value of a named property.

#### Parameters

- `key` the property name to sort on.

### `take`

Take the first `n` elements from the collection.

#### Parameters

- `howMany` - the number of elements to select from the collection.

### `toSentence`

Convert a collection of strings into a sentence.

#### Parameters

- `conjunction` - The word to use to separate the last element of the list. Defaults to `'and'`.
- `oxfordComma` - Boolean. Whether or not to put a comma immediately before the conjunction. Defaults to `false`.

### `uniq`

see: [Ember.Enumerable#uniq](http://emberjs.com/api/classes/Ember.Enumerable.html#method_uniq)

### `without`

see: [Ember.Enumerable#without](http://emberjs.com/api/classes/Ember.Enumerable.html#method_without)


## License
Copyright (c) 2013 Resistor Ltd.
Licensed under the MIT license.
