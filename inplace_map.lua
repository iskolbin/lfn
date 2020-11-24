local function inplace_map(arr, f)
	for i = 1, #arr do
		arr[i] = f(arr[i], i, arr)
	end
	return arr
end

return inplace_map
