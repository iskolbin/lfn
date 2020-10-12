local function partition(arr, p)
	local result1, result2, j, k = {}, {}, 0, 0
	for i = 1, #arr do
		if p(arr[i], i, arr) then
			j = j + 1
			result1[j] = arr[i]
		else
			k = k + 1
			result2[k] = arr[i]
		end
	end
	return {result1, result2}
end

return partition
