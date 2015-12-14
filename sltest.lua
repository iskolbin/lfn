sl = require'sl'

local function assertq( a, b )
	return assert(sl'equal?'( a, b ))
end

assertq( 1, 1 )
assertq( {1,2}, {1,2} )
assertq( {1,2,x = 1}, {1,2,x = 1} )
assertq( {1,2,3,4}, {1,2,sl'_',4} )
assertq( {1,2,3,4,5,6}, {1,2,3,sl'...'} )

assertq( sl.range(10):toarray(), {1,2,3,4,5,6,7,8,9,10} )
assertq( sl.range(2,10):toarray(), {2,3,4,5,6,7,8,9,10} )
assertq( sl.range(3,10,3):toarray(), {3,6,9} )
assertq( sl.range(5,1):toarray(), {5,4,3,2,1} )
assertq( sl.range(10,1,-3):toarray(),{10,7,4,1} )
assertq( sl.range(-5):toarray(), {-1,-2,-3,-4,-5} )

assertq( sl.iter{2,4,6,8,10}:toarray(), {2,4,6,8,10} )
assertq( sl.iter{2,4,6,8,10}:map(sl'x+1'):toarray(), {3,5,7,9,11} )
assertq( sl.iter{2,4,6,8,10}:filter(sl'x<10'):toarray(), {2,4,6,8} )
assertq( sl.iter{1,2,3,4,5,6,7,8,9,10}:filter(sl'even?'):toarray(), {2,4,6,8,10} )
assertq( sl.iter{1,2,3,4,5,6,7}:map(sl'x^2'):filter(sl'odd?'):toarray(), {1,9,25,49} )
assertq( sl.iter{1,2,3,4,5,6,7}:reduce( sl'*', 1 ), 1*2*3*4*5*6*7 )
assertq( sl.iter{1,2,3,4,5,6,7}:sum(), 1+2+3+4+5+6+7 )
assertq( sl.iter{1,1,1,1,2,2,4,4,3,3,6,6}:unique():toarray(), {1,2,4,3,6} )
assertq( sl.iter{2,4,6,8}:withindex():zip():toarray(), {{1,2},{2,4},{3,6},{4,8}} )
assertq( sl.iter{2,4,6,8}:withindex(-1):zip():toarray(), {{-1,2},{0,4},{1,6},{2,8}} )
assertq( sl.iter{2,4,6,8}:withindex(2,0.5):zip():toarray(), {{2,2},{2.5,4},{3,6},{3.5,8}} )
assertq( sl.iter{0,1,3,6,1}:withindex():zip():toarray(), sl.ipairs{0,1,3,6,1}:zip():toarray())
assertq( sl.iter{2,3,4,5,6,7,8}:take(3):toarray(), {2,3,4} )
assertq( sl.iter{2,3,4,5,6,7,8,5,6,7}:takewhile( sl'x~=5' ):toarray(), {2,3,4} )
assertq( sl.iter{2,3,4,5,6,7,8,5,6,7}:takewhile( sl'x<=6' ):toarray(), {2,3,4,5,6} )
assertq( sl.iter{2,4,6,8}:drop(2):toarray(), {6,8} )
assertq( sl.iter{2,4,6,8,2,4,6,8}:dropwhile( sl'even?' ):toarray(), {} )
assertq( sl.iter{2,4,6,8,2,4,6,8,1,2,3,4}:dropwhile( sl'even?' ):toarray(), {1,2,3,4} )
assertq( sl.iter{2,4,6,8}:delete{[4] = true}:toarray(), {2,6,8} )
assertq( sl.iter{2,4,6,8}:dup():update{[4] = 3, [8] = 1}:swap():toarray(), {2,3,6,1} )
assertq( select( 2, sl.iter{42,3,4,6}:next()), 42 )
assertq( sl.iter{1,3,6,1,3,4,9}:toarray():sort(), {1,1,3,3,4,6,9} )
assertq( sl.iter{1,2,3,4,5}:toarray():reverse(), {5,4,3,2,1} )
assertq( sl.iter{1,9,2,8,3,6,4}:toarray():indexof( 8 ), 4 )
assertq( sl.iter{1,9,2,8,3,6,4}:toarray():sort(sl'<'):indexof( 8 ), 6 )
assertq( sl.iter{1,8,2,8,3,6,4}:toarray():sort(sl'>'):indexof( 8, sl'>' ), 2 )
assertq( sl.iter{1,2,3,4}:swap():swap():sum(), 10 )
assertq( sl.iter({2,4,6,8},2):toarray(), {4,6,8} )
assertq( sl.iter({2,4,6,8},-2):toarray(),{6,8} )
assertq( sl.iter({2,4,6,8,10},1,5,2):toarray(),{2,6,10})
assertq( sl.iter({2,4,6,8,10},-1,1):toarray(),{10,8,6,4,2})
assertq( sl.iter({2,4,5,6},-1):toarray(),{6})
assertq( sl.iter({2,4,6,8,2},2,-1,2):toarray(),{4,8})

local s = 0
sl.iter{1,4,3,2,1,6}:each( function( v ) s = s + v end )
assertq( s, 17 )

assertq( sl.ipairs{2,4,6,8}:zip():toarray(), {{1,2},{2,4},{3,6},{4,8}} )
assertq( sl.ipairs{2,4,6,8}:swap():toarray(), {2,4,6,8} )
--sl.pairs{ x = 3, y = 1, z = 12}:swap():each(print)

assertq( sl.pairs{ x = 3, y = 1, z = 12}:swap():sum(), 16 )
assertq( sl.keys{x = 3, y = 1, z = 12, a = 3, b = 4, c = 9}:toarray():sort(), {'a','b','c','x','y','z'} )
assertq( sl.values{x = 3, y = 1, z = 12, a = 3, b = 4, c = 9}:toarray():sort(), {1,3,3,4,9,12} )
assertq( sl.values{ x= 3, y = 4, z = 3}:swap():swap():sum(), 10 )
assertq( sl.pairs{x = 3, y = 1, z = 12}:totable(), {x = 3, y = 1, z =12 } )
assertq( sl.pairs{[3] = 1, [5] = 6, [2] = 2}:sum(), 10 )

assertq( sl.pairs{x = 3, y = 1, z = 12}:filter( sl'y~=1' ):zip():toarray():sort( sl'x[2]>y[2]' ), {{'z',12},{'x',3}} )

assertq( sl.wrap{1,2,3,4,5}:copy(), {1,2,3,4,5} )

local x = {1,2,3,4}
assert( sl.wrap( x ):copy() ~= x )

local t = {x = 5, y = 2, 1, 2 }
assert( sl.wrap( t ):tcopy() ~= t )

assertq( sl.wrap( t ):tcopy(), {x = 5, y = 2, 1, 2 } )
assertq( sl.wrap( t ):keyof( 5 ), 'x' )

print('shuffle')
sl.wrap{1,2,3,4,5,6,7,8}:shuffle(math.random):iter():each(print)

print('all passed')
