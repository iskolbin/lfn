local function kvswap(tbl)
	local result = {}
	for k, v in pairs(tbl) do
		result[v] = k
	end
	return result
end

return kvswap
