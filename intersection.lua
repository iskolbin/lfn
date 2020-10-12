local select, pairs = _G.select, _G.pairs

local function intersection(tbl, ...)
	local result, n = {}, select("#", ...)
	if n > 0 then
		for k, v in pairs(tbl) do
			local has_intersections = true
			for i = 1, n do
				if select(i, ...)[k] == nil then
					has_intersections = false
					break
				end
			end
			if has_intersections then
				result[k] = v
			end
		end
	end
	return result
end

return intersection
