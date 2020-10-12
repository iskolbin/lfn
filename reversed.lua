local libpath = select(1, ...):match(".+%.") or ""

local reverse = require(libpath .. "reverse")
local copyarray = require(libpath .. "copyarray")

local function reversed(arr)
	return reverse(copyarray(arr))
end

return reversed
