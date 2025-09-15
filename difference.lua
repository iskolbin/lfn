local select, pairs = _G.select, _G.pairs

local function difference(tbl, ...)
	local result, n = {}, select("#", ...)
	if n == 0 then
		return tbl
	end
	for k, v in pairs(tbl) do
		local unique = true
		for i = 1, n do
			local t = select(i, ...)
			if t[k] ~= nil then
				unique = false
				break
			end
		end
		if unique then
			result[k] = v
		end
	end
	return result
end

return difference
