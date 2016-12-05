![Build Status](https://travis-ci.org/iskolbin/lfn.svg?branch=master)

Lua functional library
======================

```lua
-- Very inefficient but compact quicksort implementation

local fn = require'fn'

local function qsort( a )
	if fn.len( a ) > 1 then
		local pivot, tail = fn( a ):partition( fn'|x,i| i == 1' )
		local left, right = tail:partition( fn.rcur.lt( pivot[1] ))
		return qsort( left ):merge( pivot ):merge( qsort( right ))
	else
		return a
	end
end
```

Usage
-----

* `fn.copy( table )` makes a shallow copy of the `table` and set helper metatable to allow chain calls using `:` syntax
* `fn.wrap( table )` set helper metatable directly, which overwrites current metatable of passed `table`
* `fn.range( limit )` creates range from 1 to `limit > 0` or from -1 to `limit < 0`, with helper metatable set, for `limit == 0` returns empty array
* `fn.range( init, limit )` creates range from `init` to `limit` with helper metatable set, it's ok if `limit < init`
* `fn.range( init, limit, step )` creates range from `init` to `limit` by `step` with helper metatable set
* `fn.chars( string )` creates array with UTF-8 chars extracted from `string`
* `fn.chars( string, pattern )` creates array with substrings from `string` extracted using `pattern`. To get all chars just as is use `"."` pattern

Array transforms
----------------

* `map( array, f )` transforms passed array by mapping with signature `f(value,index,array) => newvalue`
* `filter( array, p )` filters elements from array which hold predicate `p(value,index,array) => boolean`
* `shuffle( array )` shuffles array using `math.random` generator
* `shuffle( array, random )` shuffles array using custom RNG
* `sub( array, init )` create a slice of array starting from `init` to the end of `array`, negative indices are allowed
* `sub( array, init, limit )` create a slice of array from `init` to `limit`
* `sub( array, init, limit, step )` create a slice of array from `init` to `limit` with `step`
* `reverse( array )` reverses array
* `insert( array, index, ... )` inserts values from before the specified `index`. If `index < 0` then place is counted from the end of `array`, i.e. `-1` is after the last item, `-2` is before the last item
* `append( array, ... )` alias for `insert( array, -1, ...) `
* `merge( array1, array2 )` appends `array2` items after `array1`
* `merge( array1, array2, cmp )` create sorted array from 2 sorted arrays using `cmp` comparator
* `remove( array, ... )` removes values from the `array`
* `partition( array, p )` splits array into 2 parts by predicate `p(value,index,array) => boolean` and returns 2 arrays
* `flatten( array )` flattens the array
* `sort( array )` sorts the `array` copy by `fn.lt` ordering and returns the result
* `sort( array, cmp )` sorts the `array` using custom ordering
* `unique( array )` returns array without duplicate values
* `ipairs( array )` returns array filled with array pairs `{index,value}`
* `frompairs( array )` transforms array with pairs `{key,value}` to table
* `zip( ... )` maps tuple of sequences into a sequence of tuples, i.e. `zip({a,b},{1,2},{x,y}) => {{a,1,x},{b,2,y}}`
* `unzip( array )` maps sequence of tuples into tuple of sequences

Table transforms
----------------

* `keys( table )` returns array with `table` keys
* `values( table )` returns array with `table` values
* `pairs( table )` returns array filled with table pairs `{key,value}`
* `sortedpairs( table )` returns array filled with table pairs `{key,value}` sorted by `fn.ltall` predicate
* `update( table, upd )` updates `table` content from the `upd` table, adding new values, to delete table entry one need to pass `fn.NIL` value

Folds
-----

* `foldl( array, f, acc )` common reduce from the begining of `array`, reduces by the function `f(v,acc,i,arr) => acc,stop` where if `stop` is notfalsy the reducing process halts
* `foldr( array, f, acc )` reduce from the end of `array`
* `sum( array )` returns sum of `array` elements
* `all( array, p )` returns `true` if all `array` elements hold `p( value, index, array) => bool`
* `any( array, p )` returns `true` if any of the `array` element holds `p( value, index, array ) => bool`
* `count( array, p )` counts number of `array` items for which predicate `p( value, index, array ) => bool` holds
* `indexof( array, value )` linear search of the `value` in the `array`
* `indexof( array, value, cmp )` binary search of the `value` in the sorted `array` with `cmp` ordering
* `find( array, p )` linear search of the value which holds `p( value, index, array ) => bool`
* `nkeys( table )` returns total count of keys in `table`
* `equal( v1, v2 )` checks `v1` and `v2` on deep equality, tables are supported but without table keys, also you can use `fn._` as the wildcard
* `tostring( v )` returns jsony like representation of passed value
* `concat` == `table.concat`
* `unpack` == `table.unpack`
* `setmetatable` == `setmetatable`
* `fn.pack` == `table.pack or {...}`

String lambda
-------------

* `fn.lambda( source )`, create simple string lambda from `source` which has form `|<args>|<body expression` which transforms into
```lua
function(<args>)
	return <body expression>
end
```

Aliases
-------

* `fn( table )` == `fn.copy( table )`
* `fn( string )` == `fn.lambda( string )`
