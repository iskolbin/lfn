local unpack = table.unpack or unpack -- Lua 5.1 compatibility
local setmetatable, select, next = setmetatable, select, next

local function reccall( self, i, status, ... )
	if status then
		if self[i] then
			return reccall( self, i+2, self[i]( self[i+1], ... ))
		else
			return status,...
		end
	else
		return status
	end
end

local Array = {
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
		local oarray = setmetatable( {}, ArrayMt )
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
			assert( type( cmp ) == 'function', '3rd argument should be nil for linear search and comparator for binary search' )
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
}

local ArrayMt = { __index = Array }

local Generator = {
	apply = function( self, f, arg )
		self[#self+1] = f
		self[#self+1] = arg
		return self
	end,
	
	map = function( self, f_ )
		local function map( f, ... )
			return true, f( ... )
		end

		return self:apply( map, f_ )
	end,
	
	filter = function( self, p_ )
		local function filter( p, ... )
			if p( ... ) then
				return true, ...
			else
				return false
			end
		end

		return self:apply( filter, p_ )
	end,

	pack = function( self, from_ )
		local function pack( from, k, v, ... )
			if from <= 1 then return true, {...}
			elseif from <= 2 then return true, k, {v,...}
			elseif from <= 3 then return true, k, v, {...}
			else
				local allargs = {...}
				allargs[from+1] = {select( from, ... )}
				allargs[from+2] = nil
				return true, unpack( allargs ) 
			end
		end

		return self:apply( pack, from_ )
	end,

	swap = function( self )
		local function swap( _, x, y, ... )
			return true, y, x, ...
		end

		return self:apply( swap, false )
	end,

	unique = function( self )
		local function unique( cache, k, ... )
			if not cache[k] then
				cache[k] = true
				return true, k, ...
			else
				return false
			end
		end
		
		return self:apply( unique, {} )
	end,

	update = function( self, table_ )
		local function update( table, k, v, ... )
			if table[k] then
				return true, k, table[k], ...
			else
				return false, k, v, ...
			end
		end

		return self:apply( update, table_ )
	end,

	delete = function( self, table_ )
		local function delete( table, k, ... )
			if not table[k] then
				return true, k, ...
			else
				return false
			end
		end

		return self:apply( delete, table_ )
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

		return self:reduce( arrayfold, setmetatable( {}, ArrayMt ) )
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
		return self[2]( self )
	end,
}

local GeneratorMt = {__index = Generator}

local function iternext( self )
	local index = self[4] + 1
	local value = self[3][index]
	if value ~= nil then
		self[4] = index
		return reccall( self, 5, true, value ) 
	end
end

local function ipairsnext( self )
	local index = self[4] + 1
	local value = self[3][index]
	if value ~= nil then
		self[4] = index
		return reccall( self, 5, true, index, value ) 
	end
end

local function riternext( self )
	local index = self[4] - 1
	local value = self[3][index]
	if value ~= nil then
		self[4] = index
		return reccall( self, 5, true, value ) 
	end
end

local function ripairsnext( self )
	local index = self[4] - 1
	local value = self[3][index]
	if value ~= nil then
		self[4] = index
		return reccall( self, 5, true, index, value ) 
	end
end

local function pairsnext( self )
	local k, v = next( self[3], self[4] )
	if k ~= nil then
		self[4] = k
		return reccall( self, 5, true, k, v )
	end
end

local function keysnext( self )
	local k, v = next( self[3], self[4] )
	if k ~= nil then
		self[4] = k
		return reccall( self, 5, true, k )
	end
end

local function valuesnext( self )
	local k, v = next( self[3], self[4] )
	if k ~= nil then
		self[4] = k
		return reccall( self, 5, true, v )
	end
end

local function rangenext( self )
	self[3] = self[3] + self[5]
	if self[3] <= self[4] then
		return reccall( self, 6, true, self[3] )
	end
end

local function invrangenext( self )
	self[3] = self[3] + self[5]
	if self[3] >= self[4] then
		return reccall( self, 6, true, self[3] )
	end
end

local Rest = {}
local Wild = {}

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
}

local StreamLibrary = {
	_ = Wild,
	___ = Rest,

	range = function( init, limit, step )
		local init, limit, step = init, limit, step
		if not limit then
			init, limit = 1, init
		end
		if not step then
			step = init < limit and 1 or -1
		end
		if init <= limit and step > 0 then
			return setmetatable( {rangehasnext,rangenext,init-step,limit,step}, GeneratorMt )
		elseif init >= limit and step < 0 then
			return setmetatable( {invrangehasnext,invrangenext,init-step,limit,step}, GeneratorMt )
		end
	end,
	iter = function( table ) return setmetatable( {iterhasnext,iternext,table,0}, GeneratorMt ) end,
	ipairs = function( table ) return setmetatable( {iterhasnext,ipairsnext,table,0}, GeneratorMt ) end,
	riter = function( table ) return setmetatable( {riterhasnext,riternext,table,#table+1}, GeneratorMt ) end,
	ripairs = function( table ) return setmetatable( {riterhasnext,ripairsnext,table,#table+1}, GeneratorMt ) end,
	pairs = function( table ) return setmetatable( {pairshasnext,pairsnext,table}, GeneratorMt ) end,
	keys = function( table ) return setmetatable( {pairshasnext,keysnext,table}, GeneratorMt ) end,
	values = function( table ) return setmetatable( {pairshasnext,valuesnext,table}, GeneratorMt ) end,
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

return setmetatable( StreamLibrary, {
	__call = lambda,
} )
