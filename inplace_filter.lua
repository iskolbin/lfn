local function inplace_filter(arr, p)
	local j, n = 0, #arr
	for i = 1, n do
		if p(arr[i], i, arr) then
			j = j + 1
			arr[j] = arr[i]
		end
	end
	for i = j + 1, n do
		arr[i] = nil
	end
	return arr
end

return inplace_filter
