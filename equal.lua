local libpath = select(1, ...):match(".+%.") or ""
local _ = require(libpath .. "wild")

local type, pairs = _G.type, _G.pairs

local function equal(a, b, wild)
	wild = wild or _
	if a == b or a == wild or b == wild then
		return true
	elseif type(a) == "table" and type(b) == "table" then
		for k, v in pairs(a) do
			if not equal(v, b[k], wild) then
				return false
			end
		end
		for k, v in pairs(b) do
			if not equal(v, a[k], wild) then
				return false
			end
		end
		return true
	else
		return false
	end
end

return equal
