# lfn
Lua functional library

## Usage
* `fn.copy( table )` makes a shallow copy of the `table` and set helper metatable to allow chain calls using `:` syntax
* `fn.wrap( table )` set helper metatable directly, which overwrites current metatable of passed `table`
* `fn.range( limit )` creates range from 1 to `limit > 0` or from -1 to `limit < 0`, with helper metatable set, for `limit == 0` returns empty array
* `fn.range( init, limit )` creates range from `init` to `limit` with helper metatable set, it's ok if `limit < init`
* `fn.range( init, limit, step )` creates range from `init` to `limit` by `step` with helper metatable set

## Array transforms
* `map( array, f )` transforms passed array by mapping with signature `f(value,index,array) => newvalue`
* `filter( array, p )` filters elements from array which hold predicate `p(value,index,array) => boolean`
* `shuffle( array )` shuffles array using `math.random` generator
* `shuffle( array, random )` shuffles array using custom RNG
* `sub( array, init )` create a slice of array starting from `init` to the end of `array`, negative indices are allowed
* `sub( array, init, limit )` create a slice of array from `init` to `limit`
* `sub( array, init, limit, step )` create a slice of array from `init` to `limit` with `step`
* `reverse( array )` reverses array
* `insert( array, ins )` inserts values from `ins` into the end of specified `array`
* `insert( array, index, ins )` inserts values from `ins` before the specified `index`
* `remove( array, rem )` removes listed in `rem` array values from the `array`
* `partition( array, p )` splits array into 2 parts by predicate `p(value,index,array) => boolean` and returns 2 arrays
* `flatten( array )` flattens the array
* `sort( array )` sorts the `array` copy by `fn.lt` ordering and returns the result
* `sort( array, cmp )` sorts the `array` using custom ordering
* `unique( array )` returns array without duplicate values
* `ipairs( array )` returns array filled with array pairs `{index,value}`
* `frompairs( array )` transforms array with pairs `{key,value}` to table

## Table transforms
* `keys( table )` returns array with `table` keys
* `values( table )` returns array with `table` values
* `pairs( table )` returns array filled with table pairs `{key,value}`
* `sortedpairs( table )` returns array filled with table pairs `{key,value}` sorted by `fn.ltall` predicate
* `update( table, upd )` updates `table` content from the `upd` table, adding new values, changing old, to delete table entry one need to pass `fn.NIL` value

## Folds
* `foldl( array, f, acc )` common reduce from the begining of `array`, reduces by function `f(v,acc,i,arr) => acc,stop` where if `stop` is notfalsy the reducing process halts
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

## String lambda
* `fn.lambda( source )`, create simple string lambda from `source` which has form `|<args>|<body expression` which transforms into
```lua
function(<args>)
	return <body expression>
end
```

## Aliases
* `fn( table )` == `fn.copy( table )`
* `fn( string )` == `fn.lambda( string )`
