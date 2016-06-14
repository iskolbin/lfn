local Fn
local FnMt
local FnOpCache = setmetatable( {}, {__mode = 'kv'} )
local loadstring, unpack = loadstring or load, table.unpack or unpack
local setmetatable, getmetatable, type, pairs = setmetatable, getmetatable, type, pairs

local Wild = {}
local Rest = {}
local Var = {}
local RestVar = {}

local function equal( itable1, itable2, matchtable )
	if itable1 == itable2 or itable2 == Wild or itable2 == Rest then
		return true
	elseif getmetatable( itable2 ) == Var then
		if not itable2[2] or itable2[2]( itable1 ) then
			if matchtable then
				matchtable[itable2[1]] = itable1
			end
			return true
		else
			return false
		end
	else
		local t1, t2 = type( itable1 ), type( itable2 )
		if t1 == t2 and t1 == 'table' then
			local n1 = 0; for _, _ in pairs( itable1 ) do n1 = n1 + 1 end
			local n2 = 0; for _, _ in pairs( itable2 ) do n2 = n2 + 1 end
			local last2 = itable2[#itable2]
			local mt2 = getmetatable( last2 )
			if n1 == n2 or last2 == Rest or mt2 == RestVar then
				for k, v in pairs( itable2 ) do
					if v == Rest then
						return true
					elseif getmetatable( v ) == RestVar then
						local rest = {itable1[k]}
						for _, v_ in next, itable1, k do
							rest[#rest+1] = v_
						end
						if not v[2] or v[2]( rest ) then
							if matchtable then
								matchtable[v[1]] = rest
							end
							return true
						else
							return false
						end
					elseif itable1[k] == nil or not equal( itable1[k], v, matchtable ) then
						return false
					end
				end
				return true
			else
				return false
			end
		else
			return false
		end
	end
end

local function tostring_( arg, saved_, ident_ )
	local t = type( arg )
	local saved, ident = saved_ or {n = 0, recursive = {}}, ident_ or 0
	if t == 'nil' or t == 'boolean' or t == 'number' or t == 'function' or t == 'userdata' or t == 'thread' then
		return tostring( arg )
	elseif t == 'string' then
		return ('%q'):format( arg )
	else
		if saved[arg] then
			return '<table rec:' .. saved[arg] .. '>'
		else
			saved.n = saved.n + 1
			saved[arg] = saved.n
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
				return '{' .. retc .. ( retc ~= '' and tretc ~= '' and ',' or '') .. tretc .. '|' .. saved[arg] .. '}'
			end
		end
	end
end

local function ltall( a, b )
	local t1, t2 = type( a ), type( b )
	if t1 == t2 and (t1 == 'number' or t1 == 'string') then
		return a < b
	elseif t1 ~= t2 then
		return t1 < t2
	else
		return tostring( a ) < tostring( b )
	end
end

Fn = {
	each = function( iarray, f )
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
	
	sum = function( iarray, acc_ )
		local acc = acc_ or 0
		for i = 1, #iarray do
			acc = iarray[i] + acc
		end
		return acc
	end,
	
	shuffle = function( iarray, rand_ )
		local rand = rand_ or math.random
		local oarray = {}
		for i = 1, #iarray do
			oarray[i] = iarray[i]
		end
		for i = #iarray, 1, -1 do
			local j = rand( i )
			oarray[j], oarray[i] = oarray[i], oarray[j]
		end
		return setmetatable( oarray, FnMt )
	end,

	slice = function( iarray, init_, limit_, step_ )
		local init, limit, step = init_, limit_ or #iarray, step_ or 1

		if init < 0 then init = #iarray + init + 1 end
		if limit < 0 then limit = #iarray + limit + 1 end

		local oarray, j = {}, 0
		for i = init, limit, step do
			j = j + 1
			oarray[j] = iarray[i]
		end
		return setmetatable( oarray, FnMt )
	end,

	reverse = function( iarray )
		local oarray, n = {}, #iarray + 1
		for i = n, 1, -1 do
			oarray[n - i] = iarray[i]
		end
		return setmetatable( oarray, FnMt )
	end,

	insert = function( iarray, toinsert, pos_ )
		local n, m, oarray = #iarray, #toinsert, {}
		local pos = pos_ or n+1
		pos = pos < 0 and n + pos + 2 or pos
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
		return setmetatable( oarray, FnMt )
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
		return setmetatable( oarray, FnMt )
	end,

	partition = function( iarray, p )
		local oarray, j, k = {setmetatable({}, FnMt),setmetatable({}, FnMt)}, 0, 0
		for i = 1, #iarray do
			if p( iarray[i] ) then
				j = j + 1
				oarray[1][j] = iarray[i]
			else
				k = k + 1
				oarray[2][k] = iarray[i]
			end
		end
		return setmetatable( oarray, FnMt )
	end,

	flatten = function( iarray )
		local function doFlatten( t, v, index )
			if type( v ) == 'table' then
				for k = 1, #v do index = doFlatten( t, v[k], index ) end
			else
				index = index + 1
				t[index] = v
			end
			return index
		end

		local oarray, j = {}, 0
		for i = 1, #iarray do 
			j = doFlatten( oarray, iarray[i], j ) 
		end
		return setmetatable( oarray, FnMt )
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
		return setmetatable( oarray, FnMt )
	end,

	map = function( iarray, f )
		local oarray = {}		
		for i = 1, #iarray do
			oarray[i] = f( iarray[i] )
		end
		return setmetatable( oarray, FnMt )
	end,

	imap = function( iarray, f )
		local oarray = {}		
		for i = 1, #iarray do
			oarray[i] = f( i, iarray[i] )
		end
		return setmetatable( oarray, FnMt )
	end,

	keys = function( itable )
		local oarray, i = {}, 0
		for k, _ in pairs( itable ) do
			i = i + 1
			oarray[i] = k
		end
		return setmetatable( oarray, FnMt )
	end,

	values = function( itable )
		local oarray, i = {}, 0
		for _, v in pairs( itable ) do
			i = i + 1
			oarray[i] = v
		end
		return setmetatable( oarray, FnMt )
	end,

	copy = function( itable )
		if type( itable ) == 'table' then
			local otable = {}
			for k, v in pairs( itable ) do
				otable[Fn.copy( k )] = Fn.copy( v )
			end
			return setmetatable( otable, FnMt )
		else
			return itable
		end
	end,

	sort = function( iarray, cmp )
		local oarray = Fn.copy( iarray )
		table.sort( oarray, cmp )
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
			local init, limit = 1, #iarray
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
		local oarray = {}
		for i = 1, #iarray do
			oarray[i] = {i,iarray[i]}
		end
		return setmetatable( oarray, FnMt )
	end,

	sortedpairs = function( itable, lt )
		local oarray, i = {}, 0
		for k, _ in pairs( itable ) do
			i = i + 1
			oarray[i] = k
		end
		table.sort( oarray, lt or ltall )
		for j = 1, i do
			local k = oarray[j]
			oarray[j] = {k,itable[k]}
		end
		return setmetatable( oarray, FnMt )
	end,

	pairs = function( itable )
		local oarray, i = {}, 0
		for k, v in pairs( itable ) do
			i = i + 1
			oarray[i] = {k,v}
		end
		return setmetatable( oarray, FnMt )
	end,

	frompairs = function( iarray )
		local otable = {}
		for i = 1, #iarray do
			local k, v = iarray[i][1], iarray[i][2]
			otable[k] = v
		end
		return setmetatable( otable, FnMt )
	end,

	update = function( itable, utable )
		local otable = Fn.copy( itable )
		for k, v in pairs( utable ) do
			otable[k] = v
		end
		return otable
	end,

	delete = function( itable, dtable )
		local otable = Fn.copy( itable )
		for _, v in pairs( dtable ) do
			otable[v] = nil
		end
		return otable
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
		return setmetatable( oarray, FnMt )
	end,

	nkeys = function( itable )
		local n = 0
		for _, _ in pairs( itable ) do
			n = n + 1
		end
		return n
	end,

	length = function( itable ) 
		return #itable 
	end,
	
	match = function( a, b, ... )
		local acc = {}
		local result = equal( a, b, acc ) 
		if result then
			return setmetatable( acc, FnMt )
		else
			local n = select( '#', ... )
			for i = 1, n do
				acc = next( acc ) == nil and acc or {}
				result = equal( a, select( i, ... ), acc )
				if result then 
					return setmetatable( acc, FnMt )
				end
			end
			return result
		end
	end,
	
	equal = equal,
	concat = table.concat,
	unpack = unpack,
	setmetatable = setmetatable,
	getmetatable = getmetatable,
	tostring = tostring_,

	pack = table.pack or function(...) return {...} end,
	var = function( a, b ) return setmetatable( {a, b}, Var ) end,
	restvar = function( a, b ) return setmetatable( {a, b}, RestVar ) end,
}

FnMt = {
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
	['[]'] = function( a, b ) return b[a] end,
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
	['id?'] = function( a ) return type( a ) == 'string' and a:match('^[%a_][%w_]*') ~= nil end,
	['empty?'] = function( a ) return next( a ) == nil end,
	['...'] = Rest,
	['_'] = Wild,
	['<@'] = ltall,
}

Fn.Op.X = Fn.var'X'
Fn.Op.Y = Fn.var'Y'
Fn.Op.Z = Fn.var'Z'
Fn.Op.N = Fn.var( 'N', Fn.Op['number?'] )
Fn.Op.S = Fn.var( 'S', Fn.Op['string?'] )
Fn.Op.R = Fn.restvar'R'

local FnOpMT = {
	__index = function( _, k )
		local f = FnOpCache[k]
		if not f then
			f = assert(loadstring( 'return function(x,y,z,...) return ' .. k .. ' end' ))()
			FnOpCache[k] = f
		end
		return f
	end,
}

setmetatable( Fn.Op, FnOpMT )

local function range( init_, limit_, step_ )
	local init, limit, step = init_, limit_, step_
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
	return setmetatable( array, FnMt )
end

return function( tbl, ... )
	local t = type( tbl )
	if t == 'string' then
		return Fn.Op[tbl]
	elseif t == 'table' then	
		return setmetatable( tbl, FnMt )
	elseif t == 'number' then
		return range( tbl, ... )
	elseif t == 'nil' then
		return Fn
	else
		error( 'Argument should be either string(for operator) or table or numbers or nil' )
	end
end
