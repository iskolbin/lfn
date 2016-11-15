-- Lua functional library
-- created by Ilya Kolbin (iskolbin@gmail.com)
-- originally hosted at github.com/iskolbin/lfn

local fn = {
	ID_PATTERN = '^[%a_][%w_]*$',
	NIL = {},
	_ = {},
}

local setmetatable, getmetatable, type, pairs, tostring = setmetatable, getmetatable, type, pairs, tostring

function fn.len( a )
	return #a 
end

function fn.proxy( ... ) return ... end
function fn.truth() return true end
function fn.lie() return false end
function fn.neg( a ) return -a end
function fn.add( a, b ) return a + b end
function fn.subtract( a, b ) return a - b end
function fn.mul( a, b ) return a * b end
function fn.div( a, b ) return a / b end
function fn.mod( a, b ) return a % b end
function fn.pow( a, b ) return a ^ b end
function fn.idiv( a, b ) return math.floor( a / b ) end
function fn.inc( a ) return a + 1 end
function fn.dec( a ) return a - 1 end
function fn.land( a, b ) return a and b end
function fn.lor( a, b ) return a or b end
function fn.lnot( a ) return not a end
function fn.lxor( a, b ) return (a and not b) or (b and not a ) end
function fn.conc( a, b ) return a .. b end
function fn.lt( a, b ) return a < b end
function fn.le( a, b ) return a <= b end
function fn.eq( a, b ) return a == b end
function fn.ne( a, b ) return a ~= b end
function fn.gt( a, b ) return a > b end
function fn.ge( a, b ) return a >= b end
function fn.isnil( a ) return a == nil end
function fn.iszero( a ) return a == 0 end
function fn.ispositive( a ) return a > 0 end
function fn.isnegative( a ) return a < 0 end
function fn.iseven( a ) return a % 2 == 0 end
function fn.isodd( a ) return a % 2 ~= 0 end
function fn.isnumber( a ) return type( a ) == 'number' end
function fn.isinteger( a ) return type( a ) == 'number' and math.floor( a ) == a end
function fn.isboolean( a ) return type( a ) == 'boolean' end
function fn.isstring( a ) return type( a ) == 'string' end
function fn.isfunction( a ) return type( a ) == 'function' end
function fn.istable( a ) return type( a ) == 'table' end
function fn.isuserdata( a ) return type( a ) == 'userdata' end
function fn.isthread( a ) return type( a ) == 'thread' end
function fn.isid( a ) return type( a ) == 'string' and a:match( fn.ID_PATTERN ) ~= nil end
function fn.isempty( a ) return next( a ) == nil end

fn.comp = (function()
	local cache = setmetatable( {}, {__mode = 'kv'} )
	return function( f, g ) 
		local fs = cache[f]
		if not cache[f] then
			fs = setmetatable( {}, {__mode = 'kv'} )		
			cache[f] = fs
		end
		local gs = fs[g]
		if not gs then
			gs = function(...) 
				return f( g(...) )
			end
			fs[g] = gs
		end
		return gs
	end
end)()

fn.mem = (function()
	local fcache = {}
	return function( f, v, i )
		i = i or 1
		assert( i >= 1 )
		if not fcache[i] then
			fcache[i] = setmetatable( {}, {__mode = 'kv'} )
		end
		cache = fcache[i]
		local fs = cache[f]
		if not cache[f] then
			fs = setmetatable( {}, {__mode = 'kv'} )		
			cache[f] = fs
		end
		local vs = fs[v]
		if not vs then
			if i == 1 then vs = function(...) return f(v,...) end
			elseif i == 2 then vs = function(a1,...) return f(a1,v,...) end
			elseif i == 3 then vs = function(a1,a2,...) return f(a1,a2,v,...) end
			elseif i == 4 then vs = function(a1,a2,a3,...) return f(a1,a2,a3,v,...) end
			elseif i == 5 then vs = function(a1,a2,a3,a4,...) return f(a1,a2,a3,a4,v,...) end
			elseif i == 6 then vs = function(a1,a2,a3,a4,a5,...) return f(a1,a2,a3,a4,a5,v,...) end
			else vs = function(...)
				local args = {...}
				args[i] = v
				return f(unpack(args))
			end
			end
			fs[v] = vs
		end
		return vs
	end
end)()

local function lcur( f, v ) return fn.mem( f, v ) end
local function rcur( f, v ) return fn.mem( f, v, 2 ) end

fn.lcur = setmetatable( {}, {
	__index = function( _, fname ) return fn.mem( lcur, fn[fname] ) end,
	__call = function( _, f, v ) return lcur( f, v ) end,
})

fn.rcur = setmetatable( {}, {
	__index = function( _, fname ) return fn.mem( rcur, fn[fname] ) end,
	__call = function( _, f, v ) return rcur( f, v ) end,
})

local function dotostring( arg, saved_, level_ )
	local t = type( arg )
	local saved, level = saved_ or {n = 0, recursive = {}}, level_ or 0
	if t == 'nil' or t == 'boolean' or t == 'number' or t == 'function' or t == 'userdata' or t == 'thread' then
		return tostring( arg )
	elseif t == 'string' then
		if arg:match( fn.ID_PATTERN ) then
			return arg
		else
			return ('%q'):format( arg )
		end
	else
		if saved[arg] then
			return '<table rec:' .. saved[arg] .. '>'
		else
			saved.n = saved.n + 1
			saved[arg] = saved.n
			local isarray, ret, na = true, {}, fn.len( arg )
			for i = 1, na do
				ret[i] = dotostring( arg[i], saved, level )
			end
			local tret, nt = {}, 0
			for k, v in pairs(arg) do
				if not ret[k] then
					isarray = false
					nt = nt + 1
					tret[nt] = (' '):rep(2*(level+1)) .. dotostring( k, saved, level+1 ) .. ': ' .. dotostring( v, saved, level+1 )
				end
			end
			local retc, tretc = table.concat( ret, ',' ), table.concat( tret, ',\n' )
			if tretc ~= '' then
				tretc = '\n' .. tretc
			end
			return (isarray and '[%s%s%s]' or '{%s%s%s}'):format( retc, retc ~= '' and tretc ~= '' and ',' or '', tretc )
		end
	end
end

fn.tostring = dotostring

local fnmt = { __index = fn, __tostring = dotostring }

function fn.wrap( t )
	return setmetatable( t, fnmt )
end

function fn.ltall( a, b )
	local t1, t2 = type( a ), type( b )
	if t1 == t2 and (t1 == 'number' or t1 == 'string') then
		return a < b
	elseif t1 ~= t2 then
		return t1 < t2
	else
		return tostring( a ) < tostring( b )
	end
end

function fn.foldl( iarray, f, acc )
	for i = 1, fn.len( iarray ) do
		acc, stop = f( iarray[i], acc, i, iarray )
		if stop then
			return acc
		end
	end
	return acc
end

function fn.foldr( iarray, f, acc )
	for i = fn.len( iarray ), 1, -1 do
		acc, stop = f( iarray[i], acc, i, iarray )
		if stop then
			return acc
		end
	end
	return acc
end
	
function fn.sum( iarray, acc_ )
	local acc = acc_ or 0
	for i = 1, fn.len( iarray ) do
		acc = iarray[i] + acc
	end
	return acc
end
	
function fn.shuffle( iarray, rand_ )
	local rand = rand_ or math.random
	local oarray = fn.wrap{}
	for i = 1, fn.len( iarray ) do
		oarray[i] = iarray[i]
	end
	for i = fn.len( iarray ), 1, -1 do
		local j = rand( 1, i )
		oarray[j], oarray[i] = oarray[i], oarray[j]
	end
	return oarray
end

function fn.sub( iarray, init_, limit_, step_ )
	local len = fn.len( iarray )
	local init, limit, step = init_, limit_ or len, step_ or 1
	if init < 0 then 
		init = len + init + 1
	end
	if limit < 0 then 
		limit = len + limit + 1
	end
	init, limit = math.max( 1, math.min( init, len )), math.max( 1, math.min( limit, len ))
	local oarray, j = fn.wrap{}, 0
	for i = init, limit, step do
		j = j + 1
		oarray[j] = iarray[i]
	end
	return oarray
end

function fn.reverse( iarray )
	local oarray, n = fn.wrap{}, fn.len( iarray ) + 1
	for i = n, 1, -1 do
		oarray[n - i] = iarray[i]
	end
	return oarray
end

function fn.insert( iarray, toinsert_pos, toinsert_ )
	local toinsert = toinsert_ and toinsert_ or toinsert_pos
	local n, m, oarray = fn.len( iarray ), fn.len( toinsert ), fn.wrap{}
	local pos = toinsert_ and toinsert_pos or n+1
	pos = pos < 0 and n + pos + 2 or pos
	assert( type( toinsert ) == 'table', 'second argument must be a table of insertable elements' )
	if pos <= 1 then
		for i = 1, m do oarray[i] = toinsert[i] end
		for i = 1, n do oarray[m+i] = iarray[i] end
	elseif pos > n then
		for i = 1, n do oarray[i] = iarray[i] end
		for i = 1, m do oarray[i+n] = toinsert[i] end
	else
		for i = 1, pos-1 do oarray[i] = iarray[i] end
		for i = 1, m do oarray[i+pos-1] = toinsert[i] end
		for i = pos, n do oarray[i+m] = iarray[i] end
	end
	return oarray
end

function fn.remove( iarray, toremove )
	local oarray, j, torm = fn.wrap{}, 0, {}
	for i = 1, fn.len( toremove ) do
		torm[ toremove[i]] = true
	end
	for i = 1, fn.len( iarray ) do
		local v = iarray[i]
		if not torm[v] then
			j = j + 1
			oarray[j] = v
		end
	end
	return oarray
end

function fn.partition( iarray, p )
	local oarray1, oarray2, j, k = fn.wrap{}, fn.wrap{}, 0, 0
	for i = 1, fn.len( iarray ) do
		if p( iarray[i], i, iarray ) then
			j = j + 1
			oarray1[j] = iarray[i]
		else
			k = k + 1
			oarray2[k] = iarray[i]
		end
	end
	return oarray1, oarray2
end

local function doflatten( t, v, index )
	if type( v ) == 'table' then
		for k = 1, fn.len( v ) do 
			index = doflatten( t, v[k], index ) 
		end
	else
		index = index + 1
		t[index] = v
	end
	return index
end

function fn.flatten( iarray )
	local oarray, j = fn.wrap{}, 0
	for i = 1, fn.len( iarray ) do 
		j = doflatten( oarray, iarray[i], j ) 
	end
	return oarray
end

function fn.count( iarray, p )
	local n = 0
	for i = 1, fn.len( iarray ) do
		if p( iarray[i], i, iarray ) then
			n = n + 1
		end
	end
	return n
end

function fn.all( iarray, f )
	for i = 1, fn.len( iarray ) do
		if not f( iarray[i], i, iarray ) then
			return false
		end
	end
	return true
end

function fn.any( iarray, f )
	for i = 1, fn.len( iarray ) do
		if f( iarray[i], i, iarray ) then
			return true
		end
	end
	return false
end
	
function fn.filter( iarray, p )
	local oarray, j = {}, 0
	for i = 1, fn.len( iarray ) do
		if p( iarray[i], i, iarray ) then
			j = j + 1
			oarray[j] = iarray[i]
		end
	end
	return fn.wrap( oarray )
end

function fn.map( iarray, f )
	local oarray = fn.wrap{}		
	for i = 1, fn.len( iarray ) do
		oarray[i] = f( iarray[i], i, iarray )
	end
	return oarray
end

function fn.keys( itable )
	local oarray, i = fn.wrap{}, 0
	for k, _ in pairs( itable ) do
		i = i + 1
		oarray[i] = k
	end
	return oarray
end

function fn.values( itable )
	local oarray, i = fn.wrap{}, 0
	for _, v in pairs( itable ) do
		i = i + 1
		oarray[i] = v
	end
	return oarray
end

function fn.copy( itable )
	if type( itable ) == 'table' then
		local otable = fn.wrap{}
		for k, v in pairs( itable ) do
			otable[k] = v
		end
		return otable
	else
		return itable
	end
end

function fn.sort( iarray, cmp )
	local oarray = fn.copy( iarray )
	table.sort( oarray, cmp )
	return oarray
end

function fn.indexof( iarray, v, cmp )
	if not cmp then
		for i = 1, fn.len( iarray ) do
			if iarray[i] == v then
				return i
			end
		end
	else
		assert( type( cmp ) == 'function', '3rd argument should be nil for linear search and comparator for binary search' )
		local init, limit = 1, fn.len( iarray )
		local floor = math.floor
		while init <= limit do
			local mid = floor( 0.5*(init+limit))
			local v_ = iarray[mid]
			if v == v_ then return mid
			elseif cmp( v, v_ ) then limit = mid - 1
			else init = mid + 1
			end
		end
	end
end

function fn.find( iarray, p )
	for i = 1, fn.len( iarray ) do
		if p( iarray[i], i, iarray ) then
			return iarray[i], i
		end
	end
end

function fn.ipairs( iarray )
	local oarray = {}
	for i = 1, fn.len( iarray ) do
		oarray[i] = {i,iarray[i]}
	end
	return fn.wrap( oarray )
end

function fn.sortedpairs( itable, lt )
	local sortedkeys, i = {}, 0
	for k, _ in pairs( itable ) do
		i = i + 1
		sortedkeys[i] = k
	end
	table.sort( oarray, lt or ltall )
	local oarray = fn.wrap{}
	for j = 1, i do
		local k = sortedkeys[j]
		oarray[j] = {k,itable[k]}
	end
	return oarray
end

function fn.pairs( itable )
	local oarray, i = fn.wrap{}, 0
	for k, v in pairs( itable ) do
		i = i + 1
		oarray[i] = {k,v}
	end
	return oarray
end

function fn.frompairs( iarray )
	local otable = fn.wrap{}
	for i = 1, fn.len( iarray ) do
		local k, v = iarray[i][1], iarray[i][2]
		otable[k] = v
	end
	return otable
end

function fn.update( itable, utable )
	local otable = fn.copy( itable )
	for k, v in pairs( utable ) do
		if v == fn.NIL then
			otable[k] = nil
		else
			otable[k] = v
		end
	end
	return otable
end

function fn.unique( iarray )
	local oarray, uniq, j = fn.wrap{}, {}, 0 
	for i = 1, fn.len( iarray ) do
		local v = iarray[i]
		if not uniq[v] then
			j = j + 1
			uniq[v] = true
			oarray[j] = v
		end
	end
	return oarray
end

function fn.nkeys( itable )
	local n = 0
	for _ in pairs( itable ) do
		n = n + 1
	end
	return n
end

function fn.range( init_, limit_, step_ )
	local init, limit, step = init_, limit_, step_
	local array = fn.wrap{}
	if not limit then
		if init == 0 then
			return array
		end
		init, limit = init > 0 and 1 or -1, init
	end
	if not step then
		step = init < limit and 1 or -1
	end
	local j = 0
	for i = init, limit, step do
		j = j + 1
		array[j] = i
	end	
	return array
end

fn.concat = table.concat
fn.getmetatable = getmetatable
fn.setmetatable = setmetatable
fn.unpack = table.unpack or unpack
fn.pack = table.pack or function(...) return {...} end

fn.lambda = (function()
	local loadstring = loadstring or load
	local cache = setmetatable( {}, {__mode = 'kv'} )
	return function( code )
		local f = cache[code]
		if not f then
			local args = assert( code:match( '^%b||' ), 'string lambda syntax is \'|<args>|<body>\'' )
			local body = code:gsub( args,'' )
			f = assert( loadstring( 'return function(' .. args:sub(2,-2) .. ') return ' .. body .. ' end' ))()
			cache[code] = f
		end
		return f
	end
end)()

local function equal( a, b )
	if a == b or a == fn._ or b == fn._ then
		return true
	elseif type( a ) == 'table' and type( b ) == 'table' then
		for k, v in pairs( a ) do
			if not equal( v, b[k] ) then
				return false
			end
		end
		for k, v in pairs( b ) do
			if not equal( v, a[k] ) then
				return false
			end
		end
		return true
	else
		return false
	end
end

fn.equal = equal

return setmetatable( fn, {__call = function(_,t)
	if type( t ) == 'table' then
		return fn.copy( t )
	elseif type( t ) == 'string' then
		return fn.lambda( t )
	else
		error( 'fn accepts tables or strings as arguments' )
	end
end} )
