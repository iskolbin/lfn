# lfn
Lua functional library

## Usage
1. `fn( table )` -- copy table and set helper metatable to copied table to allow chain calls
```lua
fn( <table> ):<transform>:<transform>...:setmetatable() -- if we don't need helper metatable at the end
fn( <table> ):<transform>:<transform>...:<fold>
```

2. `fn.range(<init>,<limit>,<step>)` -- creates range with helper metatable set
```lua
fn( 5 ) -- {1,2,3,4,5}
fn( 2, 5 ) -- {2,3,4,5}
fn( 3, 6, 2 ) -- {3,5}
fn( 4 ):sum() -- 10
```
## Array transforms
* ipairs( array )
* map( array, f )
* filter( array, predicate )
* shuffle( array[, random=math.random] )
* slice( array, init[, limit=end of array, step=1] )
* reverse( array )
* insert( array, insarray[, pos=end of array] )
* remove( array, remarray[, cmp=nil] )
* partition( array, predicate )
* flatten( array )
* sort( array[, cmp=less than ] )
* unique( array )
* frompairs( array )

# Table transforms
* copy( array )
* keys( table )
* values( table )
* pairs( table )
* update( table, updtable ), to delete pass to updtable `fn.NIL` value

# Folds
* foldl( array, f, acc ), `f(v,acc,i,arr) => acc` 
* foldr( array, f, acc ), `f(v,acc,i,arr) => acc`
* sum( array[, acc=0] )
* all( array, p ), `p(v,i) => bool`
* any( array, p ), `p(v,i) => bool`
* count( array, p ), `p(v,i) => bool`
* indexof( array, value[, cmp=less than] )
* find( array, p ), `p(v,i) => bool`
* nkeys( table )
* equal( v1, v2 )
* tostring( v )
* concat == table.concat
* unpack == table.unpack
* setmetatable == setmetatable
* pack == table.pack

## String lambda
`fn.lambda'<lambda code>` or just `fn'<lambda code>`. Lambda syntax is follow:
`fn'|<args>|<body expression>'` which transformed into
```lua
function(<args>)
	return <body expression>
end
```

