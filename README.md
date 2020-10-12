[![Build Status](https://travis-ci.org/iskolbin/lfn.svg?branch=master)](https://travis-ci.org/iskolbin/lfn)
[![license](https://img.shields.io/badge/license-public%20domain-blue.svg)](http://unlicense.org/)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)


Lua functional library
======================

* `fn.copy(value)` makes a shallow copy of the `table` or just returns any other value
* `fn.copyarray(array)` makes a shallow copy of the `array`
* `fn.range(limit)` creates range from 1 to `limit > 0` or from -1 to `limit < 0`, for `limit == 0` returns empty array
* `fn.range(init, limit)` creates range from `init` to `limit`, it's ok if `limit < init`
* `fn.range(init, limit, step)` creates range from `init` to `limit` by `step`
* `fn.utf8chars(string)` creates array with UTF-8 chars extracted from `string`
* `fn.chars(string)` creates array with 8-bit chars extracted from `string`
* `fn.chars(string, pattern)` creates array with substrings from `string` extracted using `pattern`
* `fn.chain(table)` wraps table with metatable for chaining calls; call `:value()` to unwrap the result, reducers `count`, `equal`, `every`, `max`, `min`, `fold`, `foldl`, `foldr`, `product`, `some`, `str`, `sum`, `unpack` calls are always unwrapped

Array transforms
----------------

* `map(array, f)` transforms passed array by mapping with signature `f(value,index,array) => newvalue`
* `filter(array, p)` filters elements from array which hold predicate `p(value,index,array) => boolean`
* `shuffle(array)` shuffles array inplace using `math.random` generator
* `shuffle(array, random)` shuffles array inplace using custom RNG
* `shuffled(array)` shuffles array using `math.random` generator
* `shuffled(array, random)` shuffles array using custom RNG
* `sub(array, init)` create a slice of array starting from `init` to the end of `array`, negative indices are allowed
* `sub(array, init, limit)` create a slice of array from `init` to `limit`
* `sub(array, init, limit, step)` create a slice of array from `init` to `limit` with `step`
* `reverse(array)` reverses array inplace
* `reversed(array)` reverses array inplace
* `include(array, index, ...values)` inserts `values` from before the specified `index`. If `index < 0` then place is counted from the end of `array`, i.e. `-1` is after the last item, `-2` is before the last item
* `exclude(array, ...values)` removes `values` from the `array`
* `partition(array, p)` splits array into 2 parts by predicate `p(value,index,array) => boolean` and returns array with 2 inner array
* `flat(array)` flattens the array
* `flat(array, level)` flattens the array until `level`
* `sort(array)` sorts inplace using `table.sort`
* `sort(array, cmp)` sorts inplace using `table.sort` using custom ordering
* `sorted(array)` sorts the `array` copy by `<` ordering and returns the result using `table.sort`
* `sorted(array, cmp)` sorts the `array` copy using custom ordering using `table.sort`
* `sorted(array, cmp, sort)` sorts the `array` copy using custom ordering and custom sort function
* `stablesort(array)` sort the `array` inplace by `<` ordering using stable sorting
* `stablesort(array, cmp)` sorts the `array` inplace using custom ordering using stable sorting
* `unique(array)` returns array without duplicate values
* `indexed(array)` returns array filled with array pairs `{index,value}`
* `fromentries(array)` transforms array with pairs `{key, value}` to table
* `zip(...arrays)` maps tuple of sequences into a sequence of tuples, i.e. `zip({a,b},{1,2},{x,y}) => {{a,1,x},{b,2,y}}`
* `unzip(array)` maps sequence of tuples into tuple of sequences
* `frequencies(array)` return table filled with count of occurencies of specific item
* `chunk(array, ...size)` returns array partitioned on chunks of passed size
* `min(array)` returns minimal element of the `array`
* `max(array)` returns maxmial element of the `array`
* `each(array, f)` calls `f` on each `array` element; returns passed `array`

Table transforms
----------------

* `keys(table)` returns array with `table` keys
* `values(table)` returns array with `table` values
* `entries(table)` returns array filled with table pairs `{key,value}`
* `sortedentries(table)` returns array filled with table pairs `{key,value}` sorted by `<` using `table.sort`
* `sortedentries(table, cmp)` returns array filled with table pairs `{key,value}` sorted by `cmp` using `table.sort`
* `sortedentries(table, cmp, sort)` returns array filled with table pairs `{key,value}` sorted by `cmp` using `sort` function
* `update(table, upd)` updates `table` content from the `upd` table, adding new values, to delete table entry one need to pass `fn.NIL` value
* `diff(table, table)` returns table with diff's (nested), if tables are equal returns an empty table; deleted fields marked as `fn.NIL`
* `patch(table, table)` returns table with applied patch, merging two tables; to delete field one should pass `fn.NIL`; plays nice with `diff`


Set operations
--------------

* `difference(table, ...tables)` returns `table` without keys in `tables`
* `intersection(table, ...tables)` returns `table` with keys which exist in all `tables`
* `union(table, ...tables)` returns `table` merged with `tables`(values of `table` will not be overwritten)

Folds
-----

* `fold(table, f, acc)` generic reduce, reduces by the function `f(acc, value, key, table) => acc, stop` where if `stop` is notfalsy the reducing process halts
* `foldl(array, f, acc)` common reduce from the begining of `array`, reduces by the function `f(acc, value, index, array) => acc, stop` where if `stop` is notfalsy the reducing process halts
* `foldr(array, f, acc)` reduce from the end of `array`
* `sum(array)` returns sum of `array` elements
* `every(array, p)` returns `true` if all `array` elements hold `p(value, index, array) => bool`
* `sine(array, p)` returns `true` if any of the `array` element holds `p(value, index, array) => bool`
* `count(array, p)` counts number of `array` items for which predicate `p(value, index, array) => bool` holds
* `indexof(array, value)` linear search of the `value` in the `array`
* `indexof(array, value, cmp)` binary search of the `value` in the sorted `array` with `cmp` ordering
* `find(array, p)` linear search of the value which holds `p(value, index, array) => bool`
* `count(table)` returns total count of entries in `table`
* `count(table, p)` returns count of entries for which `p(value, index, array) => bool` holds
* `equal(v1, v2)` checks `v1` and `v2` on deep equality, nested tables are supported but without table keys (except some simple cases), also you can use `fn._` as the wildcard
* `str(v)` returns jsony like representation of passed value
* `concat` == `table.concat`
* `unpack` == `table.unpack`
* `setmetatable(mt)` == `setmetatable`
* `pack` == `table.pack or {...}`

String lambda
-------------

* `fn.lambda(source)`, create simple string lambda from `source` which has numbered arguments with @ prefix, i.e. `@1`, `@2` and so on which transforms into single expression.
```lua
local lt = fn.lambda[[@1 < @2]]
-- compiles to
local lt = function(__1__,__2__)
	return __1__ < __2__
end
```

You can also use first argument without index:

```lua
local add2 = function(__1__)
	return __1__+2
end
```

Varargs is used for partial application:

```lua
local lt2 = fn.lambda([[@2 < @1]], 2)
-- compiles to (something like, its closure actually)
local __1__ = 2
lt2 = function(__2__)
	return __2__ < __1__
end
```

Aliases
-------

* `fn(table)` => `fn.chain(table)`
* `fn(string)` => `fn.lambda(string)`
* `fn(number)` => `fn.chain(fn.range(number))`
* `fn(number, number)` => `fn.chain(fn.range(number, number))`
* `fn(number, number, number)` => `fn.chain(fn.range(number, number, number))`
