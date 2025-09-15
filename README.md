[![Build Status](https://travis-ci.org/iskolbin/lfn.svg?branch=master)](https://travis-ci.org/iskolbin/lfn)
[![license](https://img.shields.io/badge/license-public%20domain-blue.svg)](http://unlicense.org/)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

# Lua functional library

- `fn.chars(string)` creates array with 8-bit chars extracted from `string`
- `fn.chars(string, pattern)` creates array with substrings from `string` extracted using `pattern`
- `fn.copy(value)` makes a shallow copy of the `table` or just returns any other value
- `fn.copyarray(array)` makes a shallow copy of the `array`
- `fn.deepcopy(value)` makes a deep copy of the `table` or just returns any other value
- `fn.range(limit)` creates range from 1 to `limit > 0` or from -1 to `limit < 0`, for `limit == 0` returns empty array
- `fn.range(init, limit)` creates range from `init` to `limit`, it's ok if `limit < init`
- `fn.range(init, limit, step)` creates range from `init` to `limit` by `step`
- `fn.utf8chars(string)` creates array with UTF-8 chars extracted from `string`
- `fn.chain(table)` wraps table with metatable for chaining calls; call `:value()` to unwrap the result, reducers `at`, `get`, `count`, `equal`, `every`, `max`, `min`, `reducekv`, `reduce`, `product`, `some`, `str`, `sum`, `unpack` calls are always unwrapped

## Array transforms

- `at(array, idx)` returns item at `idx`, if `idx < 0` -- take starting from the end, i.e. `at(arr, -1) == arr[#arr], at(arr, -2) == arr[#arr-1]` and so on
- `chunk(array, ...size)` returns array partitioned on chunks of passed `size`
- `combinations(array, combination_size)` returns combinations with size `combination_size`, i.e. `combinations({a,b,c},2) => {{a,b},{a,c},{b,c}}`
- `each(array, f)` calls `f` on each `array` element; returns passed `array` (helpful for chaining)
- `exclude(array, ...values)` removes `values` from the `array`
- `filter(array, p)` filters elements from array which hold predicate `p(value,index,array) => boolean`
- `flat(array)` flattens the array
- `flat(array, level)` flattens the array until `level`
- `flatmap(array, f)` transforms passed array by mapping with signature `f(value,index,array) => newvalue` and flattens on 1 level (same as `flat(arr,1)`)
- `frequencies(array)` return table filled with count of occurencies of specific item, i.e. `frequencies({a,a,b,c}) => {a = 2, b = 1, c = 1}`
- `fromentries(array)` transforms array with pairs `{key, value}` to table
- `indexed(array)` returns array filled with array pairs `{index,value}`
- `inplace_filter(array, p)` filters elements from array inplace which hold predicate `p(value,index,array) => boolean`
- `inplace_map(array, f)` transforms passed array inplace by mapping with signature `f(value,index,array) => newvalue`
- `inplace_reverse(array)` reverses array inplace
- `inplace_shuffle(array)` shuffles array inplace using `math.random` generator
- `inplace_shuffle(array, random)` shuffles array inplace using custom RNG
- `inplace_sort(array, cmp = a - b)` sorts inplace using `table.sort`
- `insert(array, index, ...values)` inserts `values` from before the specified `index`. If `index < 0` then place is counted from the end of `array`, i.e. `-1` is after the last item, `-2` is before the last item
- `map(array, f)` transforms passed array by mapping with signature `f(value,index,array) => newvalue`
- `max(array)` returns maxmial element of the `array`
- `min(array)` returns minimal element of the `array`
- `partition(array, p)` splits array into 2 parts by predicate `p(value,index,array) => boolean` and returns array with 2 inner array
- `permutations(array)` returns all possible permutations, i.e. `permitations{a,b,c} => {{a,b,c},{b,a,c},{c,a,b},{a,c,b},{b,c,a},{c,b,a}}`
- `rep(array, n)` returns array containing `array` elements `n` times
- `rep(array, n, separator)` returns array containing `array` elements `n` times, separated by `sep` element
- `reverse(array)` returns reversed array
- `shuffle(array)` shuffles array using `math.random` generator
- `shuffle(array, random)` shuffles array using custom RNG
- `sort(array)` sorts the `array` copy by `<` ordering and returns the result using `table.sort`
- `sort(array, cmp)` sorts the `array` copy using custom ordering using `table.sort`
- `sort(array, cmp, sort)` sorts the `array` copy using custom ordering and custom sort function
- `stablesort(array)` sort the `array` inplace by `<` ordering using stable sorting
- `stablesort(array, cmp)` sorts the `array` inplace using custom ordering using stable sorting
- `sub(array, init)` create a slice of array starting from `init` to the end of `array`, negative indices are allowed
- `sub(array, init, limit)` create a slice of array from `init` to `limit`
- `sub(array, init, limit, step)` create a slice of array from `init` to `limit` with `step`
- `unique(array)` returns array without duplicate values
- `unzip(array)` maps sequence of tuples into tuple of sequences
- `zip(...arrays)` maps tuple of sequences into a sequence of tuples, i.e. `zip({a,b},{1,2},{x,y}) => {{a,1,x},{b,2,y}}`

## Table transforms

- `diff(table, table)` returns table with diff's (nested), if tables are equal returns an empty table; deleted fields marked as `fn.NIL`
- `entries(table)` returns array filled with table pairs `{key,value}`
- `get(table, ...keys)` returns `table[key1][key2]...`
- `set(table, ...keys, value)` returns `table` with changed value at `key1->key2->...`
- `inplace_update(table, k, updfn, ...)` updates inplace `k`-keyed value of `table` inplace using `updfn(k, v, tbl, ...)->v` function
- `keys(table)` returns array with `table` keys
- `values(table)` returns array with `table` values
- `update(table, k, upd, ...)` updates `k`-keyed value of `table` inplace using `updfn(k, v, tbl, ...)->v` function
- `patch(table, table)` returns table with applied patch, merging two tables; to delete field one should pass `fn.NIL`; plays nice with `diff`

## Set operations

- `makeset(...keys)` returns tables with `keys` associated with `true`
- `difference(table, ...tables)` returns `table` without keys in `tables`
- `intersection(table, ...tables)` returns `table` with keys which exist in all `tables`
- `issubset(table1, table2)` checks that `table1` is subset of `table2`
- `union(table, ...tables)` returns `table` merged with `tables`(values of `table` will not be overwritten)

## Folds

- `concat` == `table.concat`
- `count(table, p = always_true)` returns count of entries for which `p(value, index, array) => bool` holds
- `equal(v1, v2)` checks `v1` and `v2` on deep equality, nested tables are supported but without table keys (except some simple cases), also you can use `fn._` as the wildcard
- `every(array, p)` returns `true` if all `array` elements hold `p(value, index, array) => bool`
- `find(array, p)` linear search of the value which holds `p(value, index, array) => bool`
- `reducekv(table, f, acc)` generic reduce, reduces by the function `f(acc, value, key, table) => acc, stop` where if `stop` is notfalsy the reducing process halts
- `reduce(array, f, acc)` common reduce from the begining of `array`, reduces by the function `f(acc, value, index, array) => acc, stop` where if `stop` is notfalsy the reducing process halts
- `getmetatable(tbl)` == `getmetatable`
- `indexof(array, value)` linear search of the `value` in the `array`
- `indexof(array, value, cmp)` binary search of the `value` in the sorted `array` with `cmp` ordering
- `inplace_setmetatable(tbl, mt)` sets metatable for `tbl`
- `pack` == `table.pack or {...}`
- `product(array, init = 1)` returns product of `array` elements and init (default is 1)
- `setmetatable(tbl, mt)` sets metatable for copy of `tbl`
- `some(array, p)` returns `true` if any of the `array` element holds `p(value, index, array) => bool`
- `str(v, mode = 'default')` returns jsony like representation of passed value, pass 'compact' to mode for more compact tables
- `sum(array, init = 0)` returns sum of `array` elements and init
- `unpack` == `table.unpack`

## String lambda

- `fn.lambda(source)`, create simple string lambda from `source` which has numbered arguments with @ prefix, i.e. `@1`, `@2` and so on which transforms into single expression.

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

## Aliases

- `fn(table)` => `fn.chain(table)`
- `fn(string)` => `fn.lambda(string)`
