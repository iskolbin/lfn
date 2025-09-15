local assert, type, floor = _G.assert, _G.type, math.floor

local function indexof(arr, v, cmp)
	if not cmp then
		for i = 1, #arr do
			if arr[i] == v then
				return i
			end
		end
	else
		assert(
			type(cmp) == "function",
			"3rd argument should be nil for linear search or comparator for binary search if passed array is sorted"
		)
		local init, limit = 1, #arr
		while init <= limit do
			local mid = floor((init + limit) / 2)
			local result = cmp(v, arr[mid])
			if result == 0 then
				return mid
			elseif result < 0 then
				limit = mid - 1
			else
				init = mid + 1
			end
		end
	end
end

return indexof
