local libpath = select(1, ...):match(".+%.") or ""

local copy, inplace_update = require(libpath .. "copy"), require(libpath .. "inplace_update")

local function update(tbl, upd, nilval)
	return inplace_update(copy(tbl), upd, nilval)
end

return update
