local pairs = _G.pairs

local function nextsorted(tbl_keys, k)
	if k == nil then
		k = tbl_keys[3]
	else
		k = tbl_keys[2][k]
	end
	if k then
		return k, tbl_keys[1][k]
	end
end

local function sortedpairs(tbl, cmp, sort)
	sort = sort or table.sort
	local sortedkeys, i = {}, 0
	for k in pairs(tbl) do
		i = i + 1
		sortedkeys[i] = k
	end
	sort(sortedkeys, cmp)
	local mapping = {}
	for j = 1, i-1 do
		mapping[sortedkeys[j]] = sortedkeys[j+1]
	end
	return nextsorted, {tbl, mapping, sortedkeys[1]}, nil
end

return sortedpairs
