--[[

 fn - v2.3.0 - public domain Lua functional library
 no warranty implied; use at your own risk

 author: Ilya Kolbin (iskolbin@gmail.com)
 url: github.com/iskolbin/lfn

 See documentation in README file.

 COMPATIBILITY

 Lua 5.1, 5.2, 5.3, LuaJIT

 LICENSE

 See end of file for license information.

--]]

local NIL = {}

local function defaultrec( arg, _, saved, _ )
	return ('{"RECURSION_%d"}'):format( saved[arg] )
end

local fn = {
	_ = {},
	ID_PATTERN = '^[%a_][%w_]*$',
	NIL = NIL,
	UTF8_PATTERN = "([%z\1-\127\194-\244][\128-\191]*)",
	DEFAULT_TOSTRING = { ident = '  ', lsep = '\n', kvsep = ' = ', rec = defaultrec },
	COMPACT_TOSTRING = { ident = '', lsep = '', kvsep = '=', rec = defaultrec },
}

local setmetatable, getmetatable, type, pairs, tostring = setmetatable, getmetatable, type, pairs, tostring
local tonumber, select, concat = tonumber, select, table.concat
local pack, unpack = _G.table.pack or function(...) return {...} end, _G.table.unpack or _G.unpack

function fn.len( a )
	return #a
end

local len = fn.len

fn.lambda = (function()
	local loadstring = _G.loadstring or load
	local cache = setmetatable( {}, {__mode = 'kv'} )
	return function( code, ... )
		local curried = select( '#', ... )
		local fs = cache[curried]
		local fc = fs and fs[code]
		if not fc then
			local maxarg, args, noindexarg = 0, {}
			local body = code:gsub( '%@(%d+)', function( x )
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
				('local %s = ...\n'):format(concat( args, ',', 1, curried ))
				or ''

			local gencode = ('%sreturn function(%s) return %s end'):format(
				curriedargs,
				concat( args, ',', curried+1 ),
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

local function dotostring( arg, options, saved, level )
	local t = type( arg )
	options = options or fn.DEFAULT_TOSTRING
	if t == 'string' then
		return ('%q'):format( arg )
	elseif t == 'table' then
		saved, level = saved or {n = 0, recursive = {}}, level or 0
		if saved[arg] then
			return (options.rec or fn.DEFAULT_TOSTRING.rec)( arg, options, saved, level )
		else
			local ident = options.ident or fn.DEFAULT_TOSTRING.ident
			local lsep = options.lsep or fn.DEFAULT_TOSTRING.lsep
			local kvsep = options.kvsep or fn.DEFAULT_TOSTRING.kvsep
			saved.n = saved.n + 1
			saved[arg] = saved.n
			local ret, na = {}, len( arg )
			for i = 1, na do
				ret[i] = dotostring( arg[i], options, saved, level )
			end
			local tret, nt = {}, 0
			for k, v in pairs(arg) do
				if not ret[k] then
					nt = nt + 1
					local key = k
					if type( k ) ~= 'string' or not k:match( fn.ID_PATTERN ) then
						key = '[' .. dotostring( k, options, saved, level+1 ) .. ']'
					end
					tret[nt] = ident:rep(level+1) .. key .. kvsep .. dotostring( v, options, saved, level+1 )
				end
			end
			local retc, tretc = concat( ret, ',' ), concat( tret, ',' .. lsep )
			if tretc ~= '' then
				tretc = lsep .. tretc .. lsep .. ident:rep(level) .. '}'
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

local function tofunction( f )
	if type( f ) == 'string' then
		return fn.lambda( f )
	else
		return f
	end
end

function fn.foldl( self, f, acc )
	f = tofunction( f )
	for i = 1, len( self ) do
		local stop
		acc, stop = f( acc, self[i], i, self )
		if stop then
			return acc
		end
	end
	return acc
end

function fn.foldr( self, f, acc )
	f = tofunction( f )
	for i = len( self ), 1, -1 do
		local stop
		acc, stop = f( acc, self[i], i, self )
		if stop then
			return acc
		end
	end
	return acc
end

function fn.sum( self, acc )
	acc = acc or 0
	for i = 1, len( self ) do
		acc = self[i] + acc
	end
	return acc
end

function fn.shuffle( self, rand )
	rand = rand or math.random
	local result = {}
	for i = 1, len( self ) do
		result[i] = self[i]
	end
	for i = len( self ), 1, -1 do
		local j = rand( 1, i )
		result[j], result[i] = result[i], result[j]
	end
	return result
end

function fn.sub( self, init, limit, step )
	local n = len( self )
	init, limit, step = init, limit or n, step or 1
	if init < 0 then
		init = n + init + 1
	end
	if limit < 0 then
		limit = n + limit + 1
	end
	init, limit = math.max( 1, math.min( init, n )), math.max( 1, math.min( limit, n ))
	local result, j = {}, 0
	for i = init, limit, step do
		j = j + 1
		result[j] = self[i]
	end
	return result
end

function fn.reverse( self )
	local result, n = {}, len( self ) + 1
	for i = n, 1, -1 do
		result[n - i] = self[i]
	end
	return result
end

function fn.insert( self, pos, ... )
	local n, m = len( self ), select( '#', ... )
	if m == 0 then
		return self
	else
		local result = {}
		pos = pos < 0 and n + pos + 2 or pos
		pos = pos < 0 and 1 or pos > n+1 and n+1 or pos
		for i = 1, pos-1 do result[i] = self[i] end
		for i = 1, m do result[i+pos-1] = select( i, ... ) end
		for i = pos, n do result[i+m] = self[i] end
		return result
	end
end

function fn.remove( self, ... )
	local result, j, toremove = {}, 0, {}
	for i = 1, select( '#', ... ) do
		toremove[select( i, ... )] = true
	end
	for i = 1, len( self ) do
		local v = self[i]
		if not toremove[v] then
			j = j + 1
			result[j] = v
		end
	end
	return result
end

function fn.partition( self, p )
	p = tofunction( p )
	local result1, result2, j, k = {}, {}, 0, 0
	for i = 1, len( self ) do
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
		for k = 1, len( v ) do
			index = doflatten( t, v[k], index )
		end
	else
		index = index + 1
		t[index] = v
	end
	return index
end

function fn.flatten( self )
	local result, j = {}, 0
	for i = 1, len( self ) do
		j = doflatten( result, self[i], j )
	end
	return result
end

function fn.count( self, p )
	p = tofunction( p )
	local n = 0
	for i = 1, len( self ) do
		if p( self[i], i, self ) then
			n = n + 1
		end
	end
	return n
end

function fn.all( self, p )
	p = tofunction( p )
	for i = 1, len( self ) do
		if not p( self[i], i, self ) then
			return false
		end
	end
	return true
end

function fn.any( self, p )
	p = tofunction( p )
	for i = 1, len( self ) do
		if p( self[i], i, self ) then
			return true
		end
	end
	return false
end

function fn.filter( self, p )
	p = tofunction( p )
	local result, j = {}, 0
	for i = 1, len( self ) do
		if p( self[i], i, self ) then
			j = j + 1
			result[j] = self[i]
		end
	end
	return result
end

function fn.map( self, f )
	f = tofunction( f )
	local result = {}
	for i = 1, len( self ) do
		result[i] = f( self[i], i, self )
	end
	return result
end

function fn.each( self, f )
	f = tofunction( f )
	for i = 1, len( self ) do
		f( self[i], i, self )
	end
	return self
end

function fn.keys( self )
	local result, i = {}, 0
	for k in pairs( self ) do
		i = i + 1
		result[i] = k
	end
	return result
end

function fn.values( self )
	local result, i = {}, 0
	for _, v in pairs( self ) do
		i = i + 1
		result[i] = v
	end
	return result
end

function fn.copy( self )
	if type( self ) == 'table' then
		local result = {}
		for k, v in pairs( self ) do
			result[k] = v
		end
		return setmetatable( result, getmetatable( self ))
	else
		return self
	end
end

function fn.sort( self, cmp )
	cmp = tofunction( cmp )
	local result = fn.copy( self )
	table.sort( result, cmp )
	return result
end

function fn.indexof( self, v, cmp )
	if not cmp then
		for i = 1, len( self ) do
			if self[i] == v then
				return i
			end
		end
	else
		cmp = tofunction( cmp )
		assert( type( cmp ) == 'function', '3rd argument should be nil for linear search and comparator for binary search' )
		local init, limit = 1, len( self )
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
	p = tofunction( p )
	for i = 1, len( self ) do
		if p( self[i], i, self ) then
			return self[i], i
		end
	end
end

function fn.ipairs( self )
	local result = {}
	for i = 1, len( self ) do
		result[i] = {i,self[i]}
	end
	return ( result )
end

function fn.sortedpairs( self, cmp )
	cmp = tofunction( cmp )
	local sortedkeys, i = {}, 0
	for k in pairs( self ) do
		i = i + 1
		sortedkeys[i] = k
	end
	table.sort( sortedkeys, cmp )
	local result = {}
	for j = 1, i do
		local k = sortedkeys[j]
		result[j] = {k,self[k]}
	end
	return result
end

function fn.pairs( self )
	local result, i = {}, 0
	for k, v in pairs( self ) do
		i = i + 1
		result[i] = {k,v}
	end
	return result
end

function fn.frompairs( self )
	local result = {}
	for i = 1, len( self ) do
		result[self[i][1]] = self[i][2]
	end
	return result
end

function fn.update( self, utable, nilval )
	local result = fn.copy( self )
	nilval = nilval or NIL
	for k, v in pairs( utable ) do
		if v == nilval then
			result[k] = nil
		else
			result[k] = v
		end
	end
	return result
end

function fn.unique( self )
	local result, uniq, j = {}, {}, 0
	for i = 1, len( self ) do
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

function fn.min( self )
	local min = self[1]
	for i = 2, len( self ) do
		if min > self[i] then min = self[i] end
	end
	return min
end

function fn.max( self )
	local max = self[1]
	for i = 2, len( self ) do
		if max < self[i] then max = self[i] end
	end
	return max
end

function fn.range( init, limit, step )
	local array = {}
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

fn.concat = concat
fn.getmetatable = getmetatable
fn.setmetatable = setmetatable
fn.unpack = unpack
fn.pack = pack


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
	local result, i = {}, 0
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
	local result, m, k = {}, len( self ), 0
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
		local result, lists = {}, {self,...}
		for i = 1, len( lists[1] ) do
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
	local n, m, result = len( self ), len( self[1] ), {}
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
	local result = {}
	for i = 1, len( self ) do
		result[self[i]] = (result[self[i]] or 0) + 1
	end
	return result
end

function fn.chunk( self, ... )
	local n = select( '#', ... )
	if n == 0 then
		return self
	else
		local result, t = {}, {}
		local j, k, kmodn, m = 1, 1, 1, select( 1, ... )
		for i = 1, len( self ) do
			t[j] = self[i]
			if j >= m then
				result[k] = t
				kmodn, k, j, t = kmodn % n + 1, k + 1, 1, {}
				m = select( kmodn, ... )
			else
				j = j + 1
			end
		end
		if j > 1 then
			result[k] = t
		end
		return result
	end
end

function fn.intersection( self, ... )
	local result, n = {}, select( '#', ... )
	if n > 0 then
		for k, v in pairs( self ) do
			local intersection = true
			for i = 1, n do
				if select( i, ... )[k] == nil then
					intersection = false
					break
				end
			end
			if intersection then
				result[k] = v
			end
		end
	end
	return result
end

function fn.difference( self, ... )
	local result, n = {}, select( '#', ... )
	for k, v in pairs( self ) do
		local unique = true
		for i = 1, n do
			if select( i, ... )[k] ~= nil then
				unique = false
				break
			end
		end
		if unique then
			result[k] = v
		end
	end
	return result
end

function fn.union( self, ... )
	local result = fn.copy( self )
	for i = 1, select( '#', ... ) do
		for k, v in pairs( select( i, ... )) do
			if result[k] == nil then
				result[k] = v
			end
		end
	end
	return result
end

local function dodiff( t, dt, res, nilval )
	if t ~= dt then
		local ttype = type( t )
		if type( dt ) == 'table' and ttype == 'table' then
			for k, dv in pairs( dt ) do
				local v = t[k]
				if v == nil then
					res[k] = dv
				elseif v ~= dv then
					res[k] = dodiff( v, dv, {}, nilval )
				end
			end
			for k in pairs( t ) do
				if dt[k] == nil then
					res[k] = nilval
				end
			end
			if next( res ) then
				return res
			end
		else
			return dt
		end
	end
end

function fn.diff( self, other, nilval )
	if type( self ) == 'table' and type( other ) == 'table' then
		return dodiff( self, other, {}, nilval or NIL ) or {}
	else
		return other
	end
end

local function dopatch( t, dt, nilval )
	if t ~= dt then
		local ttype = type( t )
		if type( dt ) == 'table' and ttype == 'table' then
			local res = {}
			for k, v in pairs( t ) do
				res[k] = v
			end
			for k, dv in pairs( dt ) do
				local v = t[k]
				if dv == nilval then
					res[k] = nil
				elseif v == nil then
					res[k] = dv
				elseif v ~= dv then
					res[k] = dopatch( v, dv, nilval )
				end
			end
			return res
		else
			return dt
		end
	end
	return t
end

function fn.patch( self, other, nilval )
	if type( self ) == 'table' and type( other ) == 'table' then
		return ( dopatch( self, other, nilval or NIL ))
	else
		return self
	end
end

local chainfn = { value = function( self ) return unpack( self ) end }

for k, f in pairs( fn ) do
	if k == 'unpack' then
		chainfn[k] = function( self, ... )
			return unpack( self[1], ... )
		end
	elseif k == 'foldl' or k == 'foldr' or k == 'max' or k == 'min' or k == 'copy' then
		chainfn[k] = function( self, ... )
			return f( self[1], ... )
		end
	else
		chainfn[k] = function( self, ... )
			self[1], self[2] = f( self[1], ... )
			if type( self[1] ) ~= 'table' then
				return self[1], self[2]
			else
				return self
			end
		end
	end
end

local chainmt = {__index = chainfn}

function fn.chain( self )
	return setmetatable( {self}, chainmt )
end

return setmetatable( fn, {__call = function( _, t, ... )
	local ttype = type( t )
	if ttype == 'table' then
		return fn.chain( t, ... )
	elseif ttype == 'string' then
		return fn.lambda( t, ... )
	elseif ttype == 'number' then
		return fn.chain( fn.range( t, ... ))
	else
		error( 'fn accepts table, string or 1,2 or 3 numbers as the arguments' )
	end
end} )

--[[
------------------------------------------------------------------------------
This software is available under 2 licenses -- choose whichever you prefer.
------------------------------------------------------------------------------
ALTERNATIVE A - MIT License
Copyright (c) 2018 Ilya Kolbin
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
------------------------------------------------------------------------------
ALTERNATIVE B - Public Domain (www.unlicense.org)
This is free and unencumbered software released into the public domain.
Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
software, either in source code form or as a compiled binary, for any purpose,
commercial or non-commercial, and by any means.
In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and to
the detriment of our heirs and successors. We intend this dedication to be an
overt act of relinquishment in perpetuity of all present and future rights to
this software under copyright law.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
------------------------------------------------------------------------------
--]]
