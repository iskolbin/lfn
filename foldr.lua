local function foldr(arr, f, acc, startindex)
	local n = #arr
	if not acc then
		return foldr(arr, f, arr[n], n-1)
	end
	for i = startindex or n, 1, -1 do
		local stop
		acc, stop = f(acc, arr[i], i, arr)
		if stop then
			return acc
		end
	end
	return acc
end

return foldr
