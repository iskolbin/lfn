local function foldl(arr, f, acc, startindex)
	if acc == nil then
		return foldl(arr, f, arr[1], 2)
	end
	for i = startindex or 1, #arr do
		local stop
		acc, stop = f(acc, arr[i], i, arr)
		if stop then
			return acc
		end
	end
	return acc
end

return foldl
