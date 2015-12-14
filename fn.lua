local Fn
local FnMt
local FnRest = {'...'}
local FnWild = {'_'}
local FnOpCache = setmetatable( {}, {__mode = 'kv'} )
local load = load or loadstring
local unpack = table.unpack or unpack

Fn = {
	each = function( iarray, f, mode )
		for i = 1, #iarray do
			f( iarray[i] ) 
		end 
	end,

	foldl = function( iarray, f, acc )
		for i = 1, #iarray do
			acc = f( iarray[i], acc )
		end
		return acc
	end,

	foldr = function( iarray, f, acc )
		for i = #iarray, 1, -1 do
			acc = f( iarray[i], acc )
		end
		return acc
	end,
	
	sum = function( iarray )
		local acc = 0
		for i = 1, #iarray do
			acc = iarray[i] + acc
		end
		return acc
	end,
	
	shuffle = function( iarray, rand )
		local rand = rand or math.random
		local oarray = {}
		for i = 1, #iarray do
			oarray[i] = iarray[i]
		end
		for i = #iarray, 1, -1 do
			local j = rand( i )
			oarray[j], oarray[i] = oarray[i], oarray[j]
		end
		return setmetatable( oarray, FnMT )
	end,

	slice = function( iarray, init, limit, step )
		local init, limit, step = init, limit or #iarray, step or 1

		if init < 0 then init = #iarray + init + 1 end
		if limit < 0 then limit = #iarray + limit + 1 end

		local oarray, j = {}, 0
		for i = init, limit, step do
			j = j + 1
			oarray[j] = iarray[i]
		end
		return setmetatable( oarray, FnMT )
	end,

	reverse = function( iarray )
		local oarray, n = {}, #iarray + 1
		for i = n, 1, -1 do
			oarray[n - i] = iarray[i]
		end
		return setmetatable( oarray, FnMT )
	end,

	insert = function( iarray, toinsert, pos )
		local n, m, oarray = #iarray, #toinsert, {}
		local pos = pos or n+1
		pos = pos < 0 and n + pos + 2 or pos, n
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
		return setmetatable( oarray, FnMT )
	end,

	remove = function( iarray, toremove, cmp )
		local oarray, j = {}, 0
		for i = 1, #iarray do
			local v = iarray[i]
			if Fn.indexof( toremove, v, cmp ) == nil then
				j = j + 1
				oarray[j] = v
			end
		end
		return setmetatable( oarray, FnMT )
	end,

	partition = function( iarray, p )
		local oarray, j, k = {setmetatable({}, FnMT),setmetatable({}, FnMT)}, 0, 0
		for i = 1, #iarray do
			if p( iarray[i] ) then
				j = j + 1
				oarray[1][j] = iarray[i]
			else
				k = k + 1
				oarray[2][k] = iarray[i]
			end
		end
		return setmetatable( oarray, FnMT )
	end,

	count = function( iarray, p )
		local n = 0
		for i = 1, #iarray do
			if p( iarray[i] ) then
				n = n + 1
			end
		end
		return n
	end,

	all = function( iarray, f )
		for i = 1, #iarray do
			if not f( iarray[i] ) then
				return false
			end
		end
		return true
	end,

	any = function( iarray, f )
		for i = 1, #iarray do
			if f( iarray[i] ) then
				return true
			end
		end
		return false
	end,
	
	filter = function( iarray, p )
		local oarray, j = {}, 0
		for i = 1, #iarray do
			if p( iarray[i] ) then
				j = j + 1
				oarray[j] = iarray[i]
			end
		end
		return setmetatable( oarray, FnMT )
	end,

	map = function( iarray, f )
		local oarray = {}		
		for i = 1, #iarray do
			oarray[i] = f( iarray[i] )
		end
		return setmetatable( oarray, FnMT )
	end,

	keys = function( itable )
		local oarray, i = {}, 0
		for k, _ in pairs( itable ) do
			i = i + 1
			oarray[i] = k
		end
		return setmetatable( oarray, FnMT )
	end,

	values = function( itable )
		local oarray, i = {}, 0
		for _, v in pairs( itable ) do
			i = i + 1
			oarray[i] = v
		end
		return setmetatable( oarray, FnMT )
	end,

	copy = function( itable )
		local otable = {}
		for k, v in pairs( itable ) do
			otable[k] = v
		end
		return setmetatable( otable, FnMT )
	end,

	sort = function( iarray, cmp )
		local oarray = {}
		for i = 1, #iarray do
			oarray[i] = iarray[i]
		end
		table.sort( oarray, cmp )
		return setmetatable( oarray, FnMT )
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

	ipairs = function( iarray )
		local oarray, i = {}, 0
		for i = 1, #iarray do
			oarray[i] = {i,iarray[i]}
		end
		return setmetatable( oarray, FnMT )
	end,

	pairs = function( itable )
		local oarray, i = {}, 0
		for k, v in pairs( itable ) do
			i = i + 1
			oarray[i] = {k,v}
		end
		return setmetatable( oarray, FnMT )
	end,

	frompairs = function( iarray )
		local otable = {}
		for i = 1, #iarray do
			local k, v = iarray[i][1], iarray[i][2]
			otable[k] = v
		end
		return setmetatable( otable, FnMT )
	end,

	update = function( itable, utable, darray )
		local otable = {}
		for k, v in pairs( itable ) do
			otable[k] = itable[k]
		end
		if utable then
			for k, v in pairs( utable ) do
				otable[k] = v
			end
		end
		if darray then
			for i = 1, #darray do
				otable[darray[i]] = nil
			end
		end
		return setmetatable( otable, FnMT )
	end,

	unique = function( iarray )
		local oarray, uniq, j = {}, {}, 0 
		for i = 1, #iarray do
			local v = iarray[i]
			if not uniq[v] then
				j = j + 1
				uniq[v] = true
				oarray[j] = v
			end
		end
		return setmetatable( oarray, FnMT )
	end,

	nkeys = function( itable )
		local n = 0
		for _, _ in pairs( itable ) do
			n = n + 1
		end
		return n
	end,

	equal = function( itable1, itable2 )
		local t1, t2 = type( itable1 ), type( itable2 )
		if t1 == t2 then
			if itable1 == itable2 or itable2 == FnWild or itable2 == FnRest then
				return true
			elseif t1 == 'table' then
				local n1 = 0; for _, _ in pairs( itable1 ) do n1 = n1 + 1 end
				local n2 = 0; for _, _ in pairs( itable2 ) do n2 = n2 + 1 end
				if n1 == n2 or itable2[#itable2] == FnRest then
					for k, v in pairs( itable2 ) do
						if v == FnWild or v == FnRest then
							return true
						elseif itable1[k] == nil or not Fn.equal( itable1[k], v ) then
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
	end,

	concat = table.concat,

	setmetatable = setmetatable,
	
	length = function( itable ) return #itable end,

	tostring = function( arg, saved, ident )
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
						ret[i] = Fn.tostring( arg[i], saved, ident )
					end
					local tret = {}
					local nt = 0
					for k, v in pairs(arg) do
						if not ret[k] then
							nt = nt + 1
							tret[nt] = (' '):rep(ident+1) .. Fn.tostring( k, saved, ident + 1 ) .. ' => ' .. Fn.tostring( v, saved, ident + 1 )
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
	end,
}

FnMT = {
	__index = Fn
}


Fn.Op = {
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
	['equal?'] = function( a, b ) return Fn.equal( a, b ) end, 
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
	['{...}'] = function( ... ) return {...} end,
	['...'] = FnRest,
	['_'] = FnWild,
	['@'] = function( a, ... ) 
		local n = select( '#', ... )
		if n == 0 then return a
		elseif n == 1 then local x = ...; return function(b) return a(b,x) end
		elseif n == 2 then local x,y = ...; return function(b) return a(b,x,y) end
		elseif n == 3 then local x,y,z = ...; return function(b) return a(b,x,y,z) end
		else local args = {...}; return function(b) return a(b,unpack(args)) end
		end
	end, 
}

local FnOpMT = {
	__index = function( self, k )
		local f = FnOpCache[k]
		if not f then
			f = assert(load( 'return function(x,y,z,a,b,c) return ' .. k .. ' end' ))()
			FnOpCache[k] = f
		end
		return f
	end,
}

setmetatable( Fn.Op, FnOpMT )

local function range( init, limit, step )
	local init, limit = init, limit
	local array = {}
	if not limit then
		init, limit = 1, init
	end
	if not step then
		step = init < limit and 1 or -1
	end
	local j = 0
	for i = init, limit, step do
		j = j + 1
		array[j] = i
	end	
	return setmetatable( array, FnMT )
end

return function( tbl, ... )
	local t = type( tbl )
	if t == 'string' then
		return Fn.Op[tbl]
	elseif t == 'table' then	
		return setmetatable( tbl, FnMT )
	elseif t == 'number' then
		return range( tbl, ... )
	elseif t == 'nil' then
		return Fn
	else
		error( 'Argument should be either string(for operator) or table or numbers or nil' )
	end
end
