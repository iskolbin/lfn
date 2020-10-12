local pairs, select = _G.pairs, _G.select

local function union(tbl, ...)
	local result = {}
	for k, v in pairs(tbl) do
		result[k] = v
	end
	for i = 1, select("#", ...) do
		for k, v in pairs(select(i, ...)) do
			if result[k] == nil then
				result[k] = v
			end
		end
	end
	return result
end

return union
