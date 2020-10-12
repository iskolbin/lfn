local function each(arr, f)
	for i = 1, #arr do
		f(arr[i], i, arr)
	end
	return arr
end

return each
