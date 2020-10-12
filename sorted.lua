local function sorted(arr, cmp, sort)
	sort = sort or table.sort
	local result = {}
	for i = 1, #arr do
		result[i] = arr[i]
	end
	sort(result, cmp)
	return result
end

return sorted
