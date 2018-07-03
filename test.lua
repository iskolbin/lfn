local fn = require'fn'

local function assertq( a, b )
	return assert( fn.equal( a, b ), fn.tostring(a) .. ' ~= ' .. fn.tostring(b))
end

assertq( {fn.identity( 1, 2, 3 )}, {1,2,3} )
assertq( fn.truth(), true )
assertq( fn.lie(), false )
assertq( fn.neg( 33 ), -33 )
assertq( fn.neg( -42 ), 42 )
assertq( fn.add( 33, 77 ), 110 )
assertq( fn.subtract( 40, 20 ), 20 )
assertq( fn.mul( 10, 20 ), 200 )
assertq( fn.div( 20, 5 ), 4 )
assertq( fn.idiv( 23, 5 ), 4 )
assertq( fn.inc( 2 ), 3 )
assertq( fn.dec( -4 ), -5 )
assertq( fn.land( true, false ), false )
assertq( fn.land( true, true ),true )
assertq( fn.lor( true, false ),true )
assertq( fn.lor( true, true ), true )
assertq( fn.lnot( true ), false )
assertq( fn.lnot( false ), true )
assertq( fn.lxor( true, false ), true )
assertq( fn.lxor( true, true ), false )
assertq( fn.lxor( false, false ), false )
assertq( fn.gt( 5, 3 ), true )
assertq( fn.gt( 3, 5 ), false )
assertq( fn.gt( 3, 3 ), false )
assertq( fn.ge( 5, 3 ), true )
assertq( fn.ge( 3, 5 ), false )
assertq( fn.ge( 3, 3 ), true )
assertq( fn.lt( 3, 5 ), true )
assertq( fn.lt( 5, 3 ), false )
assertq( fn.lt( 3, 3 ), false )
assertq( fn.le( 3, 5 ), true )
assertq( fn.le( 5, 3 ), false )
assertq( fn.le( 3, 3 ), true )
assertq( fn.eq( 3, 3 ), true )
assertq( fn.eq( 3, 2 ), false )
assertq( fn.ne( 3, 3 ), false )
assertq( fn.ne( 3, 2 ), true )
assertq( fn.conc( 'xx', 'yy' ), 'xxyy' )
assertq( fn.iszero( 0 ), true )
assertq( fn.iszero( 2 ), false )
assertq( fn.isnil( nil ), true )
assertq( fn.isnil( 22 ), false )
assertq( fn.ispositive( 22 ), true )
assertq( fn.ispositive( -22 ), false )
assertq( fn.isnegative( 22 ), false )
assertq( fn.isnegative( -22 ), true )
assertq( fn.iseven( 10 ), true )
assertq( fn.iseven( 11 ), false )
assertq( fn.isodd( 10 ), false )
assertq( fn.isodd( 11 ), true )
assertq( fn.isinteger( 5 ), true )
assertq( fn.isinteger( 3.5 ), false )
assertq( fn.isinteger( '3.5' ), false )
assertq( fn.isboolean( true ), true )
assertq( fn.isboolean( false ), true )
assertq( fn.isboolean( nil ), false )
assertq( fn.isboolean( 11 ), false )
assertq( fn.isstring( 55 ), false )
assertq( fn.isstring("asd"), true )
assertq( fn.isfunction( function() end ), true )
assertq( fn.isfunction( math.sin ), true )
assertq( fn.isfunction( 22 ), false )
assertq( fn.istable{}, true )
assertq( fn.istable(22), false )
assertq( fn.isuserdata( io.tmpfile()), true )
assertq( fn.isuserdata( 22 ), false )
assertq( fn.isthread( coroutine.create(function()end)), true )
assertq( fn.isthread( function() end), false )
assertq( fn.isid"Abacz", true )
assertq( fn.isid"zzz123", true )
assertq( fn.isid"  Abasd", false )
assertq( fn.isid"__aa", true )
assertq( fn.isid"22ss", false )
assertq( fn.isid"asd$", false )
assertq( fn.isid"asd ", false )
assertq( fn.isempty{}, true )
assertq( fn.isempty{1}, false )
assertq( fn.isempty{x=2}, false )

assertq( fn'55'(), 55 )
assertq( fn.foldl( {1,2,3,4}, fn[[@1 * @2]], 1 ), 24 )
assertq( fn.foldr( {"d","l","r","o","W"}, fn'@2..@1', '' ), 'World' )
assertq( fn.sum{1,2,3,4}, 10 )
assertq( fn.sub({1,2,3,4,5,6,7,8,9,10}, 1, 5 ), {1,2,3,4,5} )
assertq( fn.sub({1,2,3,4,5,6,7,8,9,10}, 6, -2 ), {6,7,8,9} )
assertq( fn.sub({1,2,3,4,5,6,7,8,9,10}, -4, -2 ), {7,8,9} )
assertq( fn.sub({1,2,3,4,5,6,7,8,9,10}, 7 ), {7,8,9,10} )
assertq( fn.sub({1,2,3,4,5,6,7,8,9,10}, -1 ), {10} )
assertq( fn.sub({1,2,3,4,5},0), {1,2,3,4,5} )
assertq( fn.reverse{1,2,3,4,5}, {5,4,3,2,1} )
assertq( fn.insert({1,2,3,4,5}, -1, 6), {1,2,3,4,5,6} )
assertq( fn.insert({1,2,3,4,5}, 1, 0), {0,1,2,3,4,5} )
assertq( fn.insert({1,2,3,4,5}, 3, 2.5), {1,2,2.5,3,4,5})
assertq( fn.insert({1,2,3,4,5}, -1, 6), {1,2,3,4,5,6} )
assertq( fn.insert({1,2,3,4,5},-1, 6,7,8,9,10), {1,2,3,4,5,6,7,8,9,10} )
assertq( fn.insert({1,2,3,4,5},1, 6,7), {6,7,1,2,3,4,5} )
assertq( fn.insert({1,2,3,4,5},2, 6,7), {1,6,7,2,3,4,5} )
assertq( fn.insert({1,2,3,4,5},-2, 6,7),{1,2,3,4,6,7,5} )
assertq( fn.insert({1,2,3,4,5},-1000, 6,7),{6,7,1,2,3,4,5})
assertq( fn.insert({1,2,3,4,5},1000, 6,7),{1,2,3,4,5,6,7})
assertq( fn.remove({1,2,3,4,5}, 3,4 ), {1,2,5} )
assertq( fn.remove({1,2,3,4,5}, 1,6,3 ),{2,4,5} )
assertq( {fn.partition({1,2,3,4,5,6}, fn'@>3')},{{4,5,6},{1,2,3}})
assertq( {fn.partition({1,2,3,4,5,6}, fn.truth)}, {{1,2,3,4,5,6},{}})
assertq( fn.flatten{1,2,3,{4,{5,{6,7,{8},9},10}},11},{1,2,3,4,5,6,7,8,9,10,11})
assertq( fn.flatten{1,2,3,4}, {1,2,3,4} )
assertq( fn.count({1,2,3,4,5}, fn.isodd), 3 )
assertq( fn.count({{1},{2},{3}},fn'@[1]>2'), 1)
assertq( fn.all({1,2,3,'t'}, fn.isinteger), false )
assertq( fn.all({1,2,3,5}, fn.isinteger), true )
assertq( fn.any({1,2,3,'t',{}}, fn.istable), true )
assertq( fn.any({1,2,3,5},fn.istable), false )
assertq( fn.filter({10,20,30,40,50}, fn'@>30'), {40,50})
assertq( fn.filter({10,20,30,40,50}, fn'@2<5 and @1>30'), {40})
assertq( fn.filter({10,20,3,40,50}, fn'@3[@2] == @2'), {3})
assertq( fn.map({1,2,3,4,5}, fn.inc), {2,3,4,5,6} )
assertq( fn.map({2,3,4,5,6}, fn'(@2 > 3) and 2*@1 or -@1'), {-2,-3,-4,10,12})
assertq( fn.sort{1,2,4,5,2,3,-1},{-1,1,2,2,3,4,5})
assertq( fn.sort({1,2,4,5,2,3,-1},fn.gt), {5,4,3,2,2,1,-1})
assertq( fn.sort( fn.keys{x = 2, y = 3} ), {'x','y'} )
assertq( fn.keys{1,2,4,7}, {1,2,3,4} )
assertq( fn.sort(fn.values{x = 2, y = 3}), {2,3} )
assertq( fn.values{1,2,3,5}, {1,2,3,5} )
assertq( fn.copy{1,2,3,x=5,z={1,2}}, {1,2,3,x=5,z={1,2}})
assertq( fn.indexof({1,2,'x',4,5,6}, 'x'), 3 )
assertq( fn.indexof({1,2,3,4,5,6,7,8,9,10}, 7, fn.lt), 7 )
assertq( fn.indexof({10,9,8,7,6,5,4,3,2,1}, 7, fn.gt), 4 )
assertq( fn.find({'x','y','z','aa','b','c'},fn'@ == "aa"'), 'aa' )
assertq( fn.find({{1},{2},{3},{4}}, fn'@[1] == 3'), {3} )
assertq( fn.ipairs{2,3,4}, {{1,2},{2,3},{3,4}} )
assertq( fn.sort( fn.pairs{x = 2, y = 3, z = 4}, fn'@1[1] < @2[1]'), {{'x',2},{'y',3},{'z',4}})
assertq( fn.frompairs{{'x',2},{'y',3},{'z',4}}, {x = 2, y = 3, z = 4})
assertq( fn.update( {x = 2, y = 3, z = 4}, {z = 5}), {x = 2, y = 3, z = 5} )
assertq( fn.update( {x = 2, y = 3, z = 4}, {x = 3, a = 3, z = fn.NIL}), {x = 3, a = 3, y = 3} )
assertq( fn.unique{1,2,3,1,2,3,1,4,5}, {1,2,3,4,5} )
assertq( fn.nkeys{x = 2, y = 3}, 2 )
assertq( fn.nkeys{x = 3, y = 3, 1, 2}, 4 )
assertq( fn.range(0), {})
assertq( fn.range(-1), {-1} )
assertq( fn.range(1,5,-1), {} )
assertq( fn.range(-1,-5,1), {} )
assertq( fn.range(-1,-5), {-1,-2,-3,-4,-5} )
assertq( fn.range(5), {1,2,3,4,5} )
assertq( fn.range(2,5), {2,3,4,5} )
assertq( fn.range(5,1), {5,4,3,2,1} )
assertq( fn.range(1,6,2),{1,3,5})
assertq( fn.range(5,2,-2),{5,3})
assertq( fn.sortedpairs{x = 2, z = 3, y = 6}, {{'x',2},{'y',6},{'z',3}} )
assertq( fn.sortedpairs({[{'x'}] = 2, [{'z'}] = 3, [{'y'}] = 6}, fn[[ @1[1]<@2[1] ]] ), {{{'x'},2},{{'y'},6},{{'z'},3}} )
assertq( fn.concat( fn.reverse( fn.chars'Baroque' )), ('Baroque'):reverse())
assertq( fn.concat( fn.reverse( fn.utf8'Шаломчик' )), 'кичмолаШ' )
assertq( fn.len( fn.utf8'Вариация' ), 8 )
assertq( fn.len( fn.chars'Вариация' ), string.len( 'Вариация' ))
assertq( fn{1,2,3}:rep(3):value(), {1,2,3,1,2,3,1,2,3} )
assertq( fn{1,2,3}:rep(3,'x'):value(), {1,2,3,'x',1,2,3,'x',1,2,3} )
assertq( fn{1,2,3,4}:zip():value(), {1,2,3,4} )
assertq( fn{}:zip():value(), {} )
assertq( fn.zip( {1,2}, {'x','y'}, {55.55,66.66} ), {{1,'x',55.55},{2,'y',66.66}} )
assertq( fn.zip( {1,2}, {'x','y','z'}, {55.55} ), {{1,'x',55.55},{2,'y',nil}})
assertq( fn{{1,'x',55.55},{2,'y',66.66}}:unzip():value(), {{1,2},{'x','y'},{55.55,66.66}} )
assertq( fn.frompairs( fn.zip( {'x','y','z'}, {1,2,3})), {x = 1, y = 2, z = 3} )
assertq( fn.frequencies{ 'x', 'y', 'z', 'x', 'y', 'x' }, {x = 3, y = 2, z = 1} )
assert( fn([[@ - 2]], 2)() == 0 )
assert( fn([[@1 + @2 + @3]], 1, 2 )( 3 ) == 6 )
assertq( fn{1,2,3,4}:insert():value(), {1,2,3,4} )
assertq( fn.copy( 10 ), 10 )
assertq( fn.equal( {x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = {x = 4}} ), false )
assertq( fn.equal( {x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = {x = {}}} ), false )
assertq( fn.equal( {x = 2, y = 3, z = {x = 2}}, {x = 2, y = 4, z = {x = 2}} ), false )
assertq( fn.equal( {x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = {x = 2, u = 22}} ), false )
assertq( fn.equal( {[true] = 1}, {[true] = 1} ), true )
assertq( fn{1,2,3,4}:foldl( fn[[@1+@2,@3 == 3]], 0 ):value(), 6 )
assertq( fn{1,2,3,4}:foldl( fn[[@+@2,@3 == 3]], 0 ):value(), 6 )
assertq( fn{1,2,3,4}:foldr( fn[[@1+@2,@3 == 3]], 0 ):value(), 7 )
local x = {}
x[x] = x
assertq( x, x )
assertq( fn{1,2,3,4}:chunk():value(), {1,2,3,4} )
assertq( fn{1,2,3,4}:chunk(1):value(), {{1},{2},{3},{4}} )
assertq( fn{1,2,3,4}:chunk(2):value(), {{1,2},{3,4}} )
assertq( fn{1,2,3,4}:chunk(3):value(), {{1,2,3},{4}} )
assertq( fn{1,2,3,4}:chunk(4):value(), {{1,2,3,4}} )
assertq( fn{1,2,3,4}:chunk(1):flatten():value(), {1,2,3,4} )
assertq( fn{1,2,3,4,5}:chunk(1,2):value(), {{1},{2,3},{4},{5}} )
assertq( fn{1,2,3,4,5,6,7}:chunk(1,2,3):value(), {{1},{2,3},{4,5,6},{7}} )
assertq( fn{x = 5, y = 6, z = 8}:difference():value(), {x = 5, y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:difference{}:value(), {x = 5, y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:difference({x = 6},{}):value(), {y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:difference{x = 6}:value(), {y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:difference({x = 6, k = 8}, {y = 11, a = 18}, {c = 3,x=4}):value(), {z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:intersection{x = 1}:value(), {x = 5} )
assertq( fn{x = 5, y = 6, z = 8}:intersection():value(), {} )
assertq( fn{x = 5, y = 6, z = 8}:intersection{}:value(), {} )
assertq( fn{x = 5, y = 6, z = 8}:intersection({x = 1}, {y = 2}):value(), {} )
assertq( fn{x = 5, y = 6, z = 8}:intersection({x = 1,y = 2}, {y = 4}):value(), {y = 6} )
assertq( fn{x = 5, y = 6, z = 8}:intersection({x = 1,y = 2}, {y = 4}, {}):value(), {} )
assertq( fn{x = 5, y = 6, z = 8}:union():value(), {x = 5, y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:union{}:value(), {x = 5, y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:union{x = 11}:value(), {x = 5, y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:union({x = 11},{y = 22}):value(), {x = 5, y = 6, z = 8} )
assertq( fn{x = 5, y = 6, z = 8}:union({x = 11},{y = 22, b = 14}):value(), {b = 14, x = 5, y = 6, z = 8} )
assertq( fn{x = 5}:diff{x = 5}:value(), {} )
assertq( fn{x = 5}:diff{x = 6}:value(), {x = 6} )
assertq( fn{x = 5}:diff{x = 5, y = 5}:value(),{y = 5})
assertq( fn{x = 5}:diff{x = 6, y = 5}:value(),{x = 6, y = 5})
assertq( fn{x = 5}:diff{y = 5}:value(), {x = fn.NIL, y = 5} )
assertq( fn{x = 5}:diff{y = {z = 6}}:value(), {x = fn.NIL, y = {z = 6}})
assertq( fn{x = 5}:diff{x = {z = 6}}:value(), {x = {z = 6}} )
assertq( fn.diff( 5, 6 ), 6 )
assertq( fn.diff( {}, 'str' ), 'str' )
assertq( fn.diff( 'asd', {} ), {} )
assertq( fn{x = {y = 6}}:diff{x = {y = 6}}:value(), {} )
assertq( fn{x = {y = 6}}:diff{x = {y = 7}}:value(), {x = {y = 7}} )
assertq( fn{x = {y = 6}}:diff{x = {z = 7}}:value(), {x = {y = fn.NIL,z = 7}} )
assertq( fn{x = {y = 6}}:diff{x = 5}:value(), {x = 5})
assertq( fn{x = 5}:patch{x = 5}:value(), {x = 5} )
assertq( fn{x = 5}:patch{x = 6}:value(), {x = 6} )
assertq( fn{x = {y = 6}}:patch{x = 6}:value(), {x = 6} )
assertq( fn{x = {y = 6}, z = 55}:patch{x = {y = 5}}:value(), {x = {y = 5},z = 55} )
assertq( fn{x = 6}:patch( 3 ):value(), {x = 6} )
assertq( fn.patch( 'ddd', {x = 4}), 'ddd' )
assertq( fn.patch( 'ddd', 555 ), 'ddd' )
assertq( fn{x = {y = 6, z = {55}, u = 69}}:patch{x = {z = {n = 5}}}:value(), {x = {y = 6, z = {55, n = 5}, u = 69}} )
