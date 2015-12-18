# lfn
Lua functional library

## Usage
1. fn( table or array ) -- sets helper metatable to table and array to allow chain calls
```lua
fn( <table> ):<transform>:<transform>...:setmetatable() -- if we don't need helper metatable at the end
fn( <table> ):<transform>:<transform>...:<fold>
```
Note that metatable *overwrites*.

2. fn(<init>,<limit>,<step>) -- creates range with helper metatable set
```lua
fn( 5 ) -- {1,2,3,4,5}
fn( 2, 5 ) -- {2,3,4,5}
fn( 3, 6, 2 ) -- {3,5}
fn( 4 ):sum() -- 10
```

3. fn'<string>' -- returns predefined operator or creates simple lambda from string

4. fn() -- returns table with functions, useful for example for equality check
```lua
fn().equal( 3, {2,3,4} ) -- false

fn{2,3,4}:equal( 3 ) -- false
fn( 3 ):equal{2,3,4} -- error
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
* copy( array )
* sort( array[, cmp=less than ] )
* unique( array )
* frompairs( array )

# Table transforms
* keys( table )
* values( table )
* pairs( table )
* tcopy( table )
* update( table, updtable )
* delete( table, delarray or deltable )

# Folds
* foldl( array, f, acc )
* foldr( array, f, acc )
* sum( array[, acc=0] )
* each( array, f )
* all( array, predicate )
* any( array, predicate )
* count( array, predicate )
* indexof( array, value[, cmp=less than] )
* length( array )
* nkeys( table )
* equal( table1, table2 )
* match( table1, table2 )
* tostring( table )
* concat == table.concat
* unpack == table.unpack
* setmetatable == setmetatable

# Additional functions
* fn().pack( ... )
* fn().var( name )
* fn().restvar( name )

## String operators and lambda
* Operators: ~ + - / // \* % ^ ++ -- .. #
* Logical operators: and, or, not
* Comparsion: < <= > >= == ~=
* Predicates: zero? positive? negative? even? odd? 
* Type predicates: nil? number? integer? boolean? string? function? table? userdata? thread?
* Predefined variables for matching: \_(wild) ...(wild rest) X Y Z R( rest )
* String lambda: 
```lua
fn'x+y/z' -- same as function(x, y, z, ... ) return x + y/z end
```
