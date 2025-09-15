local type, next, floor, match = _G.type, _G.next, math.floor, string.match

local ID_PATTERN = "^[%a_][%w_]*$"

local predicates = {
	isnil = function(a)
		return a == nil
	end,
	iszero = function(a)
		return a == 0
	end,
	ispositive = function(a)
		return a > 0
	end,
	isnegative = function(a)
		return a < 0
	end,
	iseven = function(a)
		return a % 2 == 0
	end,
	isodd = function(a)
		return a % 2 ~= 0
	end,
	isnumber = function(a)
		return type(a) == "number"
	end,
	isinteger = function(a)
		return type(a) == "number" and floor(a) == a
	end,
	isboolean = function(a)
		return type(a) == "boolean"
	end,
	isstring = function(a)
		return type(a) == "string"
	end,
	isfunction = function(a)
		return type(a) == "function"
	end,
	istable = function(a)
		return type(a) == "table"
	end,
	isuserdata = function(a)
		return type(a) == "userdata"
	end,
	isthread = function(a)
		return type(a) == "thread"
	end,
	isid = function(a)
		return type(a) == "string" and match(a, ID_PATTERN) ~= nil
	end,
	isempty = function(a)
		return next(a) == nil
	end,
}

return predicates
