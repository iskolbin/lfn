local pairs = _G.pairs

local function entries(tbl)
	local result, i = {}, 0
	for k, v in pairs(tbl) do
		i = i + 1
		result[i] = {k, v}
	end
	return result
end

return entries
