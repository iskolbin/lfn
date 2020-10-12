local function map(arr, f)
	local result = {}
	for i = 1, #arr do
		result[i] = f(arr[i], i, arr)
	end
	return result
end

return map
