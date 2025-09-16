local libpath = select(1, ...):match(".+%.") or ""

local patch = require(libpath .. "patch")

local function inplace_patch(tbl1, tbl2, delval)
	return patch(tbl1, tbl2, delval, true)
end

return inplace_patch
