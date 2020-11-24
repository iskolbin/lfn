local pairs = _G.pairs

local libpath = select(1, ...):match(".+%.") or ""

local NIL, copy = require(libpath .. "nil"), require(libpath .. "copy")

local function inplace_update(tbl, upd, nilval)
	nilval = nilval or NIL
	for k, v in pairs(upd) do
		if v == nilval then
			tbl[k] = nil
		else
			tbl[k] = v
		end
	end
	return tbl
end

return inplace_update
