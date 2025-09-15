local select = _G.select

local function get(tbl, ...)
	local r = tbl
	for i = 1, select('#', ...) do
		r = r[select(i, ...)]
	end
	return r
end

return get
