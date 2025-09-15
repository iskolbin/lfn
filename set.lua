local select = _G.select

local libpath = select(1, ...):match(".+%.") or ""

local copy = require(libpath .. "copy")
local DEL = require(libpath .. "internal").DEL

local function set(tbl, ...)
	local n = select("#", ...)
	if n < 2 then
		return tbl
	end
	local res = copy(tbl)
	local r = res
	for i = 1, select("#", ...) - 2 do
		local k = select(i, ...)
		r[k] = copy(r[k])
		r = r[k]
	end
	local v = select(n, ...)
	if v == DEL then
		r[select(n - 1, ...)] = nil
	else
		r[select(n - 1, ...)] = v
	end
	return res
end

return set
