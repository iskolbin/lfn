local select, pairs = _G.select, _G.pairs

local function intersection(...)
	local result, n = {}, select("#", ...)
	if n <= 1 then
		return {}
	end
	local t1, t2 = ...
	for k, v in pairs(t1) do
		local intersects = true
		if t2[k] ~= nil then
			for i = 3, n do
				if select(i, ...)[k] == nil then
					intersects = false
					break
				end
			end
		else
			intersects = false
		end
		if intersects then
			result[k] = v
		end
	end
	return result
end

return intersection
