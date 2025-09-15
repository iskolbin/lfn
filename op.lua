local floor = math.floor

local operators = {
	identity = function(...)
		return ...
	end,
	truth = function()
		return true
	end,
	lie = function()
		return false
	end,
	neg = function(a)
		return -a
	end,
	add = function(a, b)
		return a + b
	end,
	sub = function(a, b)
		return a - b
	end,
	mul = function(a, b)
		return a * b
	end,
	div = function(a, b)
		return a / b
	end,
	idiv = function(a, b)
		return floor(a / b)
	end,
	mod = function(a, b)
		return a % b
	end,
	pow = function(a, b)
		return a ^ b
	end,
	inc = function(a)
		return a + 1
	end,
	dec = function(a)
		return a - 1
	end,
	concat = function(a, b)
		return a .. b
	end,
	lt = function(a, b)
		return a < b
	end,
	le = function(a, b)
		return a <= b
	end,
	eq = function(a, b)
		return a == b
	end,
	ne = function(a, b)
		return a ~= b
	end,
	gt = function(a, b)
		return a > b
	end,
	ge = function(a, b)
		return a >= b
	end,
	land = function(a, b)
		return a and b
	end,
	lor = function(a, b)
		return a or b
	end,
	lnot = function(a)
		return not a
	end,
	lxor = function(a, b)
		return (a and not b) or (b and not a)
	end,
}

return operators
