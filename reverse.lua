local libpath = select(1, ...):match(".+%.") or ""

local inplace_reverse = require(libpath .. "inplace_reverse")
local copyarray = require(libpath .. "copyarray")

local function reverse(arr)
	return inplace_reverse(copyarray(arr))
end

return reverse
