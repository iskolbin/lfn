local function indexof(arr, v, cmp)
	if not cmp then
		for i = 1, #arr do
			if arr[i] == v then
				return i
			end
		end
	else
		assert(type(cmp) == "function",
			"3rd argument should be nil for linear search or comparator for binary search if array is sorted")
		local init, limit = 1, #arr
		local floor = math.floor
		while init <= limit do
			local mid = floor(0.5*(init+limit))
			local v_ = arr[mid]
			if v == v_ then
				return mid
			elseif cmp(v, v_) then
				limit = mid - 1
			else
				init = mid + 1
			end
		end
	end
end

return indexof
