local pairs, select = _G.pairs, _G.select

local function union(...)
	local result = {}
	for i = 1, select("#", ...) do
		for k, v in pairs(select(i, ...)) do
			result[k] = v
		end
	end
	return result
end

return union
