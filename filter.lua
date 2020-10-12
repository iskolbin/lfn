local function filter(arr, p)
	local result, j = {}, 0
	for i = 1, #arr do
		if p(arr[i], i, arr) then
			j = j + 1
			result[j] = arr[i]
		end
	end
	return result
end

return filter
