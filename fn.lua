--[[

 fn - v1.3.1 - public domain Lua functional library
 no warranty implied; use at your own risk

 author: Ilya Kolbin (iskolbin@gmail.com)
 url: github.com/iskolbin/lfn

 See documentation in README file.

 COMPATIBILITY

 Lua 5.1, 5.2, 5.3, LuaJIT 1, 2

 LICENSE

 This software is dual-licensed to the public domain and under the following
 license: you are granted a perpetual, irrevocable license to copy, modify,
 publish, and distribute this file as you see fit.

--]]

local fn = {
	ID_PATTERN = '^[%a_][%w_]*$',
	NIL = {},
	_ = {},
	UTF8_PATTERN = "([%z\1-\127\194-\244][\128-\191]*)"
}

local setmetatable, getmetatable, type, pairs, tostring = setmetatable, getmetatable, type, pairs, tostring

function fn.len( a )
	return #a 
end

function fn.identity( ... ) return ... end
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

local function dotostring( arg, saved, level )
	local t = type( arg )
	if t == 'string' then
		return ('%q'):format( arg )
	elseif t == 'table' then
		saved, level = saved or {n = 0, recursive = {}}, level or 0
		if saved[arg] then
			return ('{"RECURSION_%d"}'):format( saved[arg] )
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
					nt = nt + 1
					local key = k
					if type( k ) ~= 'string' or not k:match( fn.ID_PATTERN ) then
						key = '[' .. dotostring( k, saved, level+1 ) .. ']'
					end
					tret[nt] = (' '):rep(2*(level+1)) .. key .. ' = ' .. dotostring( v, saved, level+1 )
				end
			end
			local retc, tretc = table.concat( ret, ',' ), table.concat( tret, ',\n' )
			if tretc ~= '' then
				tretc = '\n' .. tretc .. '\n' .. (' '):rep(2*(level)) .. '}'
			else
				tretc = '}'
			end
			return ('{%s%s%s'):format( retc, retc ~= '' and tretc ~= '}' and ',' or '', tretc )
		end
	else
		return tostring( arg )
	end
end

fn.tostring = dotostring

local fnmt = { __index = fn, __tostring = dotostring }

function fn.wrap( t )
	return setmetatable( t, fnmt )
end

function fn.foldl( self, f, acc )
	for i = 1, fn.len( self ) do
		local stop
		acc, stop = f( self[i], acc, i, self )
		if stop then
			return acc
		end
	end
	return acc
end

function fn.foldr( self, f, acc )
	for i = fn.len( self ), 1, -1 do
		local stop
		acc, stop = f( self[i], acc, i, self )
		if stop then
			return acc
		end
	end
	return acc
end
	
function fn.sum( self, acc )
	acc = acc or 0
	for i = 1, fn.len( self ) do
		acc = self[i] + acc
	end
	return acc
end
	
function fn.shuffle( self, rand )
	rand = rand or math.random
	local result = fn.wrap{}
	for i = 1, fn.len( self ) do
		result[i] = self[i]
	end
	for i = fn.len( self ), 1, -1 do
		local j = rand( 1, i )
		result[j], result[i] = result[i], result[j]
	end
	return result
end

function fn.sub( self, init, limit, step )
	local len = fn.len( self )
	init, limit, step = init, limit or len, step or 1
	if init < 0 then 
		init = len + init + 1
	end
	if limit < 0 then 
		limit = len + limit + 1
	end
	init, limit = math.max( 1, math.min( init, len )), math.max( 1, math.min( limit, len ))
	local result, j = fn.wrap{}, 0
	for i = init, limit, step do
		j = j + 1
		result[j] = self[i]
	end
	return result
end

function fn.reverse( self )
	local result, n = fn.wrap{}, fn.len( self ) + 1
	for i = n, 1, -1 do
		result[n - i] = self[i]
	end
	return result
end

function fn.insert( self, pos, ... )
	local n, m = fn.len( self ), select( '#', ... )
	if m == 0 then
		return self
	else
		local result = fn.wrap{}
		pos = pos < 0 and n + pos + 2 or pos
		pos = pos < 0 and 1 or pos > n+1 and n+1 or pos
		for i = 1, pos-1 do result[i] = self[i] end
		for i = 1, m do result[i+pos-1] = select( i, ... ) end
		for i = pos, n do result[i+m] = self[i] end
		return result
	end
end

function fn.remove( self, ... )
	local result, j, toremove = fn.wrap{}, 0, {}
	for i = 1, select( '#', ... ) do
		toremove[select( i, ... )] = true
	end
	for i = 1, fn.len( self ) do
		local v = self[i]
		if not toremove[v] then
			j = j + 1
			result[j] = v
		end
	end
	return result
end

function fn.partition( self, p )
	local result1, result2, j, k = fn.wrap{}, fn.wrap{}, 0, 0
	for i = 1, fn.len( self ) do
		if p( self[i], i, self ) then
			j = j + 1
			result1[j] = self[i]
		else
			k = k + 1
			result2[k] = self[i]
		end
	end
	return result1, result2
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

function fn.flatten( self )
	local result, j = fn.wrap{}, 0
	for i = 1, fn.len( self ) do 
		j = doflatten( result, self[i], j ) 
	end
	return result
end

function fn.count( self, p )
	local n = 0
	for i = 1, fn.len( self ) do
		if p( self[i], i, self ) then
			n = n + 1
		end
	end
	return n
end

function fn.all( self, p )
	for i = 1, fn.len( self ) do
		if not p( self[i], i, self ) then
			return false
		end
	end
	return true
end

function fn.any( self, p )
	for i = 1, fn.len( self ) do
		if p( self[i], i, self ) then
			return true
		end
	end
	return false
end
	
function fn.filter( self, p )
	local result, j = fn.wrap{}, 0
	for i = 1, fn.len( self ) do
		if p( self[i], i, self ) then
			j = j + 1
			result[j] = self[i]
		end
	end
	return result
end

function fn.map( self, f )
	local result = fn.wrap{}		
	for i = 1, fn.len( self ) do
		result[i] = f( self[i], i, self )
	end
	return result
end

function fn.keys( self )
	local result, i = fn.wrap{}, 0
	for k, _ in pairs( self ) do
		i = i + 1
		result[i] = k
	end
	return result
end

function fn.values( self )
	local result, i = fn.wrap{}, 0
	for _, v in pairs( self ) do
		i = i + 1
		result[i] = v
	end
	return result
end

function fn.copy( self )
	if type( self ) == 'table' then
		local result = fn.wrap{}
		for k, v in pairs( self ) do
			result[k] = v
		end
		return result
	else
		return self
	end
end

function fn.sort( self, cmp )
	local result = fn.copy( self )
	table.sort( result, cmp )
	return result
end

function fn.indexof( self, v, cmp )
	if not cmp then
		for i = 1, fn.len( self ) do
			if self[i] == v then
				return i
			end
		end
	else
		assert( type( cmp ) == 'function', '3rd argument should be nil for linear search and comparator for binary search' )
		local init, limit = 1, fn.len( self )
		local floor = math.floor
		while init <= limit do
			local mid = floor( 0.5*(init+limit))
			local v_ = self[mid]
			if v == v_ then return mid
			elseif cmp( v, v_ ) then limit = mid - 1
			else init = mid + 1
			end
		end
	end
end

function fn.find( self, p )
	for i = 1, fn.len( self ) do
		if p( self[i], i, self ) then
			return self[i], i
		end
	end
end

function fn.ipairs( self )
	local result = {}
	for i = 1, fn.len( self ) do
		result[i] = {i,self[i]}
	end
	return fn.wrap( result )
end

function fn.sortedpairs( self, cmp )
	local sortedkeys, i = {}, 0
	for k, _ in pairs( self ) do
		i = i + 1
		sortedkeys[i] = k
	end
	table.sort( sortedkeys, cmp )
	local result = fn.wrap{}
	for j = 1, i do
		local k = sortedkeys[j]
		result[j] = {k,self[k]}
	end
	return result
end

function fn.pairs( self )
	local result, i = fn.wrap{}, 0
	for k, v in pairs( self ) do
		i = i + 1
		result[i] = {k,v}
	end
	return result
end

function fn.frompairs( self )
	local result = fn.wrap{}
	for i = 1, fn.len( self ) do
		result[self[i][1]] = self[i][2]
	end
	return result
end

function fn.update( self, utable )
	local result = fn.copy( self )
	for k, v in pairs( utable ) do
		if v == fn.NIL then
			result[k] = nil
		else
			result[k] = v
		end
	end
	return result
end

function fn.unique( self )
	local result, uniq, j = fn.wrap{}, {}, 0 
	for i = 1, fn.len( self ) do
		local v = self[i]
		if not uniq[v] then
			j = j + 1
			uniq[v] = true
			result[j] = v
		end
	end
	return result
end

function fn.nkeys( self )
	local n = 0
	for _ in pairs( self ) do
		n = n + 1
	end
	return n
end

function fn.range( init, limit, step )
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

function fn.plain( self )
	return setmetatable( self, nil )
end

fn.lambda = (function()
	local loadstring = loadstring or load
	local cache = setmetatable( {}, {__mode = 'kv'} )
	return function( code, ... )
		local curried = select( '#', ... )
		local fs = cache[curried]
		local fc = fs and fs[code]
		if not fc then
			local maxarg, args = 0, {}
			local body = code:gsub( '%@(%d+)', function( x )
				local numx = tonumber( x )
				if tonumber( x ) > maxarg then
					maxarg = tonumber( x )
				end
				return '__' .. x .. '__'
			end )
			body, noindexarg = body:gsub( '%@', '__1__' )
			for i = 1, math.max( maxarg, curried, noindexarg == 0 and 0 or 1 ) do
				args[#args+1] = '__' .. i .. '__'
			end

			local curriedargs = curried > 0 and
				('local %s = ...\n'):format(table.concat( args, ',', 1, curried ))
				or ''

			local gencode = ('%sreturn function(%s) return %s end'):format(
				curriedargs,
				table.concat( args, ',', curried+1 ),
				body )

			fc = assert( loadstring( gencode ))
			if curried == 0 then
				fc = fc()
			end
			if not fs then
				cache[curried] = { [code] = fc }
			else
				cache[curried][code] = fc
			end
		end
		if curried == 0 then
			return fc
		else
			return fc( ... )
		end
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

function fn.chars( str, pattern )
	local result, i = fn.wrap{}, 0
	for char in str:gmatch( pattern or "." ) do
		i = i + 1
		result[i] = char
	end
	return result
end

function fn.utf8( str )
	return fn.chars( str, fn.UTF8_PATTERN )
end

function fn.rep( self, n, sep )
	local result, m, k = fn.wrap{}, fn.len( self ), 0
	for i = 1, n do
		for j = 1, m do
			k = k + 1
			result[k] = self[j]
		end
		if i < n and sep then
			k = k + 1
			result[k] = sep
		end
	end
	return result
end

function fn.zip( self, ... )
	local n = select( '#', ... ) + 1
	if n == 1 then
		return self
	else
		local result, lists = fn.wrap{}, {self,...}
		for i = 1, fn.len( lists[1] ) do
			local zipped = {}
			for j = 1, n do
				zipped[j] = lists[j][i]
			end
			result[i] = zipped
		end
		return result
	end
end

function fn.unzip( self )
	local n, m, result = fn.len( self ), fn.len( self[1] ), fn.wrap{}
	for i = 1, m do
		local unzipped = {}
		for j = 1, n do
			unzipped[j] = self[j][i]
		end
		result[i] = unzipped
	end
	return result
end

function fn.frequencies( self )
	local result = fn.wrap{}
	for i = 1, fn.len( self ) do
		result[self[i]] = (result[self[i]] or 0) + 1
	end
	return result
end

return setmetatable( fn, {__call = function( _, t, ... )
	if type( t ) == 'table' then
		return fn.copy( t )
	elseif type( t ) == 'string' then
		return fn.lambda( t, ... )
	else
		error( 'fn accepts tables or strings as arguments' )
	end
end} )
