local pairs = _G.pairs

local libpath = select(1, ...):match(".+%.") or ""

local NIL, copy = require(libpath .. "nil"), require(libpath .. "copy")

local function update(tbl, upd, nilval)
	local result = copy(tbl)
	nilval = nilval or NIL
	for k, v in pairs(upd) do
		if v == nilval then
			result[k] = nil
		else
			result[k] = v
		end
	end
	return result
end

return update
