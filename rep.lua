local function rep(arr, n, sep)
	local result, m, k = {}, #arr, 0
	for i = 1, n do
		for j = 1, m do
			k = k + 1
			result[k] = arr[j]
		end
		if i < n and sep then
			k = k + 1
			result[k] = sep
		end
	end
	return result
end

return rep
