local function unzip(arr)
	local n, m, result = #arr, #arr[1], {}
	for i = 1, m do
		local unzipped = {}
		for j = 1, n do
			unzipped[j] = arr[j][i]
		end
		result[i] = unzipped
	end
	return result
end

return unzip
