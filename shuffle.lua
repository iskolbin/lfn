local libpath = select(1, ...):match(".+%.") or ""

local inplace_shuffle = require(libpath .. "inplace_shuffle")
local copyarray = require(libpath .. "copyarray")

local function shuffle(arr, rand)
	return inplace_shuffle(copyarray(arr), rand)
end

return shuffle
