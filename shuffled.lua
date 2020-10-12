local libpath = select(1, ...):match(".+%.") or ""

local shuffle = require(libpath .. "shuffle")
local copyarray = require(libpath .. "copyarray")

local function shuffled(arr, rand)
	return shuffle(copyarray(arr), rand)
end

return shuffled
