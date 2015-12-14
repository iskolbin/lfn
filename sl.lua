local load, unpack = load or loadstring, table.unpack or unpack -- Lua 5.1 compatibility
local setmetatable, select, next, type, pairs, assert = setmetatable, select, next, type, pairs, assert

local Wild = {}
local Rest = {}

local function equal( itable1, itable2 )
	if itable1 == itable2 then
		return true
	else
		local t1, t2 = type( itable1 ), type( itable2 )
		if t1 == t2 then
			if itable2 == Wild or itable2 == Rest then
				return true
			elseif t1 == 'table' then
				local n1 = 0; for _, _ in pairs( itable1 ) do n1 = n1 + 1 end
				local n2 = 0; for _, _ in pairs( itable2 ) do n2 = n2 + 1 end
				if n1 == n2 or itable2[#itable2] == Rest then
					for k, v in pairs( itable2 ) do
						if v == Wild or v == Rest then
							return true
						elseif itable1[k] == nil or not equal( itable1[k], v ) then
							return false
						end
					end
					return true
				else
					return false
				end
			end
		else
			return false
		end
	end
end

local TableMt

local Table = {
	equal = equal,

	sort = function( iarray, cmp )
		table.sort( iarray, cmp )
		return iarray
	end,
 
	shuffle = function( iarray, rand )
		local rand = rand or math.random
		for i = #iarray, 1, -1 do
			local j = rand( i )
			iarray[j], iarray[i] = iarray[i], iarray[j]
		end
		return iarray
	end,
	
	reverse = function( iarray )
		local n = #iarray
		for i = 1, n/2 do
			iarray[i], iarray[n-i+1] = iarray[n-i+1], iarray[i]
		end
		return iarray
	end,

	copy = function( iarray )
		local oarray = setmetatable( {}, TableMt )
		for i = 1, #iarray do
			oarray[i] = iarray[i]
		end
		return oarray
	end,
	
	indexof = function( iarray, v, cmp )
		if not cmp then
			for i = 1, #iarray do
				if iarray[i] == v then
					return i
				end
			end
		else
			if not type( cmp ) == 'function' then
				error('bad argument #2 to indexof ( function expected for binary search, or nil for linear search )' )
			end

			local init, limit = 1, #iarray, 0
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
	end,
	
	tcopy = function( itable )
		local otable = setmetatable( {}, TableMt )
		for k, v in pairs( itable ) do
			otable[k] = v
		end
		return otable
	end,

	keyof = function( itable, v_ )
		for k, v in pairs( itable ) do
			if v == v_ then
				return k
			end
		end
	end,
	
	concat = table.concat,
}

local Generator = {
	apply = function( self, f, arg )
		self[#self+1] = f
		self[#self+1] = arg
		return self
	end,
	
	map = function( self, f_ )
		local function domap( f, ... )
			return true, f( ... )
		end

		return self:apply( domap, f_ )
	end,
	
	filter = function( self, p_ )
		local function dofilter( p, ... )
			if p( ... ) then
				return true, ...
			else
				return false
			end
		end

		return self:apply( dofilter, p_ )
	end,

	zip = function( self, from_ )
		local function dozip( from, k, v, ... )
			if from <= 1 then return true, {k, v, ...}
			elseif from <= 2 then return true, k, {v, ...}
			elseif from <= 3 then return true, k, v, {...}
			else
				local allargs = {...}
				allargs[from+1] = {select( from, ... )}
				allargs[from+2] = nil
				return true, unpack( allargs ) 
			end
		end

		return self:apply( dozip, from_ or 1 )
	end,

	swap = function( self )
		local function doswap( _, x, y, ... )
			return true, y, x, ...
		end

		return self:apply( doswap, false )
	end,

	dup = function( self )
		local function dodup( _, x, ... )
			return true, x, x, ...
		end

		return self:apply( dodup, false )
	end,

	unique = function( self )
		local function dounique( cache, k, ... )
			if not cache[k] then
				cache[k] = true
				return true, k, ...
			else
				return false
			end
		end
		
		return self:apply( dounique, {} )
	end,

	withindex = function( self, init, step )
		local function dowithindex( i, ... )
			local index = i[1]
			i[1] = index + i[2]
			return true, index, ...
		end

		return self:apply( dowithindex, {init or 1, step or 1} )
	end,

	take = function( self, n_ )
		local function dotake( n, ... )
			if n[1] < n[2] then
				n[1] = n[1] + 1
				return true, ...
			end
		end

		return self:apply( dotake, {0, n_} )
	end,

	takewhile = function( self, p_ )
		local function dotakewhile( p, ... )
			if p( ... ) then
				return true, ...
			end
		end

		return self:apply( dotakewhile, p_ )
	end,

	drop = function( self, n_ )
		local function dodrop( n, ... )
			if n[1] < n[2] then
				n[1] = n[1] + 1
				return false
			else
				return true, ...
			end
		end
	
		return self:apply( dodrop, {0,n_} )
	end,

	dropwhile = function( self, p_ )
		local function dodropwhile( p, ... )
			if p[2] and p[1]( ... ) then
				return false
			else
				p[2] = false
				return true, ...
			end
		end

		return self:apply( dodropwhile, {p_,true} )
	end,

	update = function( self, table_ )
		local function doupdate( table, k, v, ... )
			if table[k] then
				return true, k, table[k], ...
			else
				return true, k, v, ...
			end
		end

		return self:apply( doupdate, table_ )
	end,

	delete = function( self, table_ )
		local function dodelete( table, k, ... )
			if not table[k] then
				return true, k, ...
			else
				return false
			end
		end

		return self:apply( dodelete, table_ )
	end,

	each = function( self, f )
		local function doeach( status, ... )
			if status then
				f( ... )
				return doeach( self:next())
			elseif status == false then
				return doeach( self:next())
			end
		end
		
		return doeach( self:next())
	end,

	reduce = function( self, f, acc_ )
		local function doreduce( acc, status, ... )
			if status then
				return doreduce( f(acc, ...), self:next())
			elseif status == false then
				return doreduce( acc, self:next())
			else
				return acc
			end
		end
		
		return doreduce( acc_, self:next())
	end,

	totable = function( self )
		local function tablefold( acc, k, v )
			acc[k] = v
			return acc
		end

		return self:reduce( tablefold, {} ) 
	end,
	
	toarray = function( self )
		local function arrayfold( acc, v )
			acc[#acc+1] = v
			return acc
		end

		return self:reduce( arrayfold, setmetatable( {}, TableMt ) )
	end,

	sum = function( self, acc_ )
		local function dosum( acc, status, ... )
			if status then
				return dosum( acc + ..., self:next())
			elseif status == false then
				return dosum( acc, self:next())
			else
				return acc
			end
		end
		
		return dosum( acc_ or 0, self:next())
	end,

	count = function( self, p )
		local function docount( acc, status, ... )
			if status == nil then
				return acc
			elseif status and (p == nil or p(...)) then
				return docount( acc + 1, self:next())
			else
				return docount( acc, self:next())
			end
		end

		return docount( 0, self:next())
	end,

	next = function( self )
		return self[1]( self )
	end,
}

local GeneratorMt = {__index = Generator}

local function reccall( self, i, status, ... )
	if status then
		if self[i] then
			return reccall( self, i+2, self[i]( self[i+1], ... ))
		else
			return status, ...
		end
	else
		return status
	end
end

local function iternext( self )
	local index = self[3]
	local value = self[2][index]
	if value ~= nil and index <= self[4] then
		self[3] = index + self[5]
		return reccall( self, 6, true, value ) 
	end
end

local function ipairsnext( self )
	local index = self[3]
	local value = self[2][index]
	if value ~= nil and index <= self[4] then
		self[3] = index + self[5]
		return reccall( self, 6, true, index, value ) 
	end
end

local function riternext( self )
	local index = self[3]
	local value = self[2][index]
	if value ~= nil and index >= self[4] then
		self[3] = index + self[5]
		return reccall( self, 6, true, value ) 
	end
end

local function ripairsnext( self )
	local index = self[3]
	local value = self[2][index]
	if value ~= nil and index >= self[4] then
		self[3] = index + self[5]
		return reccall( self, 6, true, index, value ) 
	end
end

local function pairsnext( self )
	local key, value = next( self[2], self.k )
	if key ~= nil then
		self.k = key
		return reccall( self, 3, true, key, value )
	end
end

local function keysnext( self )
	local key, value = next( self[2], self.k )
	if key ~= nil then
		self.k = key
		return reccall( self, 3, true, key )
	end
end

local function valuesnext( self )
	local key, value = next( self[2], self.k )
	if key ~= nil then
		self.k = key
		return reccall( self, 3, true, value )
	end
end

local function rangenext( self )
	local index = self[2]
	if index <= self[3] then
		self[2] = index + self[4]
		return reccall( self, 5, true, index )
	end
end

local function rrangenext( self )
	local index = self[2]
	if index >= self[3] then
		self[2] = index + self[4]
		return reccall( self, 5, true, index )
	end
end

local Operators = {
	['~'] = function( a ) return -a end,
	['+'] = function( a, b ) return a + b end,
	['-'] = function( a, b ) return a - b end,
	['*'] = function( a, b ) return a * b end,
	['/'] = function( a, b ) return a / b end,
	['%'] = function( a, b ) return a % b end,
	['^'] = function( a, b ) return a ^ b end,
	['//'] = function( a, b ) return math.floor( a / b ) end,
	['++'] = function( a ) return a + 1 end,
	['--'] = function( a ) return a - 1 end,
	['and'] = function( a, b ) return a and b end,
	['or'] = function( a, b ) return a or b end,
	['not'] = function( a ) return not a end,
	['#'] = function( a ) return #a end,
	['..'] = function( a, b ) return a .. b end,
	['<'] = function( a, b ) return a < b end,
	['<='] = function( a, b ) return a <= b end,
	['=='] = function( a, b ) return a == b end,
	['~='] = function( a, b ) return a ~= b end,
	['>'] = function( a, b ) return a > b end,
	['>='] = function( a, b ) return a >= b end,
	['equal?'] = function( a, b ) return equal( a, b ) end, 
	['nil?'] = function( a ) return a == nil end,
	['zero?'] = function( a ) return a == 0 end,
	['positive?'] = function( a ) return a > 0 end,
	['negative?'] = function( a ) return a < 0 end,
	['even?'] = function( a ) return a % 2 == 0 end,
	['odd?'] = function( a ) return a % 2 ~= 0 end,
	['number?'] = function( a ) return type( a ) == 'number' end,
	['integer?'] = function( a ) return type( a ) == 'number' and math.floor( a ) == a end,
	['boolean?'] = function( a ) return type( a ) == 'boolean' end,
	['string?'] = function( a ) return type( a ) == 'string' end,
	['function?'] = function( a ) return type( a ) == 'function' end,
	['table?'] = function( a ) return type( a ) == 'table' end,
	['userdata?'] = function( a ) return type( a ) == 'userdata' end,
	['thread?'] = function( a ) return type( a ) == 'thread' end,
	['_'] = Wild,
	['...'] = Rest,
}

local function evalrangeargs( init, limit, step )
	local init, limit, step = init, limit, step
	if not limit then init, limit = init > 0 and 1 or -1, init end
	if not step then step = init < limit and 1 or -1 end
	if (init <= limit and step > 0) or (init >= limit and step < 0) then
		return init, limit, step
	else
		error('bad initial variables for range')
	end
end

local function evalsubargs( table, init, limit, step )
	local len = #table
	local init, limit, step = init or 1, limit or len, step
	if init < 0 then init = len + init + 1 end
	if limit < 0 then limit = len + init + 1 end
	if not step then step = init < limit and 1 or -1 end
	if (init <= limit and step > 0) or (init >= limit and step < 0) then
		return init, limit, step
	else
		error('bad initial variables for generator')
	end
end

local Stream = {
	range = function( init, limit, step )
		local init, limit, step = evalrangeargs( init, limit, step )
		return setmetatable( {step > 0 and rangenext or rrangenext,init,limit,step}, GeneratorMt )
	end,

	iter = function( table, init, limit, step )
		local init, limit, step = evalsubargs( table, init, limit, step )
		return setmetatable( {step > 0 and iternext or riternext,table,init,limit,step}, GeneratorMt ) 
	end,
	
	ipairs = function( table, init, limit, step ) 
		local init, limit, step = evalsubargs( table, init, limit, step )
		return setmetatable( {step > 0 and ipairsnext or ripairsnext,table,init,limit,step}, GeneratorMt ) 
	end,
	
	pairs = function( table ) 
		return setmetatable( {pairsnext,table}, GeneratorMt )
	end,
	
	keys = function( table ) 
		return setmetatable( {keysnext,table}, GeneratorMt ) 
	end,
	
	values = function( table ) 
		return setmetatable( {valuesnext,table}, GeneratorMt )
	end,

	wrap = function( table )
		return setmetatable( table, TableMt )
	end,
}

local LambdaCache = setmetatable( {}, {__mode = 'kv'} )

local function lambda( self, k )
	local f = Operators[k] or LambdaCache[k]
	if not f then
		f = assert(load( 'return function(x,y,z,...) return ' .. k .. ' end' ))()
		LambdaCache[k] = f
	end
	return f
end

TableMt = { __index = Table }

setmetatable( Table, {__index = Stream} )

return setmetatable( Stream, {
	__call = lambda,
} )
