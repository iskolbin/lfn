local pairs = _G.pairs

local function sortedentries(tbl, cmp, sort)
	sort = sort or table.sort
	local sortedkeys, i = {}, 0
	for k in pairs(tbl) do
		i = i + 1
		sortedkeys[i] = k
	end
	sort(sortedkeys, cmp)
	local result = {}
	for j = 1, i do
		local k = sortedkeys[j]
		result[j] = {k, tbl[k]}
	end
	return result
end

return sortedentries
