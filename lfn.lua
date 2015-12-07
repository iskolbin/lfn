local unpack = table.unpack or unpack
local load = load or loadstring
local Rest, Wild = {}, {}
local OperatorsCache = setmetatable( {}, {__mode = 'kv'} )
local pairs, setmetatable, next, assert, type = pairs, setmetatable, next, assert, type

local function swap( self, x, y )
	return y, x
end

local function map( f, ... )
	local v = ...
	if v then
		return f( ... )
	end
end

local function filter( p, ... )
	local v = ...
	if v and p( ... ) then
		return ...
	end
end

local function unique( cache, k )
	if k and not cache[k] then
		cache[k] = true
		return k
	end
end

local function update( t, k, v )
	if k and t[k] then
		return k, t[k]
	else
		return k, v
	end
end

local function delete( t, k, v )
	if k and not t[k] then
		return k, v
	end
end

local function reccall( self, i, ... )
	if self.ts[i] then
		return reccall( self, i+1, self.ts[i][1]( self.ts[i][2], ... ))
	else
		return ...
	end
end

local TransformFold = {
	swap = function( self )
		self.ts[#self.ts+1] = swap
		return self
	end,

	map = function( self, f )
		self.ts[#self.ts+1] = {map, f}
		return self
	end,

	filter = function( self, p )
		self.ts[#self.ts+1] = {filter, p}
		return self
	end,

	unique = function( self )
		self.ts[#self.ts+1] = {unique,{}}
		return self
	end,

	update = function( self, t )
		self.ts[#self.ts+1] = {update,t}
		return self
	end,

	delete = function( self, t )
		self.ts[#self.ts+1] = {delete,t}
		return self
	end,


	sum = function( self, acc )
		local acc = acc or 0
		local k, v = self[1]( self )
		while k do	
			local toadd = reccall( self, 1, k, v )
			if toadd ~= nil then
				acc = acc + toadd
			end
			k, v = self[1]( self )
		end
		return acc
	end,

	reduce = function( self, f, acc )
		local acc = acc or 0
		local k, v = self[1]( self )
		while k do
			local toadd = {reccall( self, 1, k, v )}
			if toadd[1] ~= nil then
				acc = f( acc, unpack( toadd ))
			end
			k, v = self[1]( self )
		end
		return acc
	end,

	toarray = function( self, acc )
		local acc = acc or {}
		local i = #acc
		local k, v = self[1]( self )
		while k do
			local toadd = reccall( self, 1, k, v )
			if toadd ~= nil then
				i = i + 1
				acc[i] = toadd
			end
			k, v = self[1]( self )
		end
		return acc
	end,
	
	totable = function( self, acc )
		local acc = acc or {}
		local k, v = self[1]( self )
		while k do
			local k_, v_ = reccall( self, 1, k, v )
			if k_ ~= nil then
				acc[k_] = v_
			end
			k, v = self[1]( self )
		end
		return acc
	end,

	each = function( self, f )
		local k, v = self[1]( self )
		while k do
			local toadd = {reccall( self, 1, k, v )}
			if toadd[1] ~= nil then
				f( unpack( toadd ))
			end
			k, v = self[1]( self )
		end
	end,

	count = function( self, p )
		local k, v = self[1]( self )
		local v = 0
		if p then
			self:filter( p )
		end
		while k do
			local toadd = reccall( self, 1, acc, k, v )
			if toadd ~= nil then
				v = v + 1
			end
			k, v = self[1]( self )
		end
	end,

	all = function( self, p )
		local k, v = self[1]( self )
		local v = 0
		self:filter( p )
		while k do
			local toadd = reccall( self, 1, acc, k, v )
			if toadd == nil then
				return false
			end
			k, v = self[1]( self )
		end
		return true
	end,

	any = function( self, p )
		local k, v = self[1]( self )
		local v = 0
		self:filter( p )
		while k do
			local toadd = reccall( self, 1, acc, k, v )
			if toadd ~= nil then
				return true
			end
			k, v = self[1]( self )
		end
		return false
	end,

	sort = function( self, lt )
		local res = self:toarray()
		table.sort( res, lt )
		return res
	end,

	shuffle = function( self, random )
		local oarray = self:toarray()
		local rand = rand or math.random
		for i = 1, #iarray do
			oarray[i] = iarray[i]
		end
		for i = #iarray, 1, -1 do
			local j = rand( i )
			oarray[j], oarray[i] = oarray[i], oarray[j]
		end
		return oarray
	end,
}

local GeneratorMT = {
	__index = TransformFold
}

local function itergen( state )
	local index = state[4] + 1
	if index <= state[3] then
		state[4] = index
		return state[2][index]
	end
end

local function ritergen( state )
	local index = state[3] - 1
	if index >= 1 then
		state[3] = index
		return state[2][index]
	end
end

local function ipairsgen( state )
	local index = state[4] + 1
	if index <= state[3] then
		state[4] = index
		return index, state[2][index]
	end
end

local function ripairsgen( state )
	local index = state[3] - 1
	if index >= 1 then
		state[3] = index
		return index, state[2][index]
	end
end

local function pairsgen( state )
	local k, v = next( state[2], state[3] )
	if k ~= nil then
		state[3] = k
		return k, v
	end
end

local function keysgen( state )
	local k, _ = next( state[2], state[3] )
	if k ~= nil then
		state[3] = k
		return k
	end
end

local function valuesgen( state )
	local k, v = next( state[2], state[3] )
	if k ~= nil then
		state[3] = k
		return v
	end
end

local function rangegen( state )
	local v = state[2]
	if v <= state[3] then
		state[2] = v + state[4]
		return v
	end
end

local function invrangegen( state )
	local v = state[2]
	if v >= state[3] then
		state[2] = v + state[4]
		return v
	end
end

donothing = { function() end }

local function range( init, limit, step )
	local init, limit, step = init, limit, step
	if not limit then
		init, limit = 1, init
	end
	if not step then
		step = init < limit and 1 or -1
	end
	if init <= limit and step > 0 then
		return setmetatable( {rangegen,init,limit,step,ts={}}, GeneratorMT )
	elseif init >= limit and step < 0 then
		return setmetatable( {invrangegen,init,limit,step,ts={}}, GeneratorMT )
	else
		return donothing
	end
end
	
local Generator = {
	iter = function( self )
		return setmetatable( {itergen,self[1],#self[1],0,ts={}}, GeneratorMT )
	end,
	
	riter = function( self )
		local n = #self[1]
		return setmetatable( {ritergen,self[1],n+1,ts={}}, GeneratorMT )
	end,

	ipairs = function( self )
		return setmetatable( {ipairsgen,self[1],#self[1],0,ts={}}, GeneratorMT )
	end,

	ripairs = function( self )
		local n = #self[1]
		return setmetatable( {ripairsgen,self[1],n+1,ts={}}, GeneratorMT )
	end,

	pairs = function(	self )
		return setmetatable( {pairsgen,self[1],nil,ts={}}, GeneratorMT )
	end,

	keys = function( self )
		return setmetatable( {keysgen,self[1],nil,ts={}}, GeneratorMT )
	end,

	values = function( self )
		return setmetatable( {valuesgen,self[1],nil,ts={}}, GeneratorMT )
	end,
}

local WrapperMT = {
	__index = Generator
}

local function equal( itable1, itable2 )
	local t1, t2 = type( itable1 ), type( itable2 )
	if t1 == t2 then
		if itable1 == itable2 or itable2 == Wild or itable2 == Rest then
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

local function indexof( iarray, v, cmp )
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
end

local function tostring_( arg, saved, ident )
	local t = type( arg )
	local saved, ident = saved or {}, ident or 0
	if t == 'nil' or t == 'boolean' or t == 'number' or t == 'function' or t == 'userdata' or t == 'thread' then
		return tostring( arg )
	elseif t == 'string' then
		return ('%q'):format( arg )
	else
		if saved[arg] then
			return '__REC__'
		else
			saved[arg] = arg
			local mt = getmetatable( arg )
			if mt ~= nil and mt.__tostring then
				return mt.__tostring( arg )
			else
				local ret = {}
				local na = #arg
				for i = 1, na do
					ret[i] = tostring_( arg[i], saved, ident )
				end
				local tret = {}
				local nt = 0
				for k, v in pairs(arg) do	
					if not ret[k] then
						nt = nt + 1
						tret[nt] = (' '):rep(ident+1) .. tostring_( k, saved, ident + 1 ) .. ' => ' .. tostring_( v, saved, ident + 1 )
					end
				end
				local retc = table.concat( ret, ',' )
				local tretc = table.concat( tret, ',\n' )
				if tretc ~= '' then
					tretc = '\n' .. tretc
				end
				return '{' .. retc .. ( retc ~= '' and tretc ~= '' and ',' or '') .. tretc .. '}'
			end
		end
	end
end

local Operators = {
	['neg'] = function( a ) return -a end,
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
	['...'] = Rest,
	['_'] = Wild,
}

local OperatorsMT = {
	__index = function( self, k )
		local f = OperatorsCache[k]
		if not f then
			f = assert(load( 'return function(x,y,z,a,b,c) return ' .. k .. ' end' ))()
			OperatorsCache[k] = f
		end
		return f
	end,
}

setmetatable( Operators, OperatorsMT )

local Aux = {
	indexof = indexof,
	tostring = tostring_,
	equal = equal,
	Wild = Wild,
	Rest = Rest,
}

return function( t, ... )
	local type_ = type( t )
	if type_ == 'number' then
		return range( t, ... )
	elseif type_ == 'table' then
		return setmetatable( {t}, WrapperMT )
	elseif type_ == 'string' then
		return Operators[t]
	else
		error('Wrong type, should be table, numbers or string')
	end
end
