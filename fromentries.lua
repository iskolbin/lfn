local function fromentries(arr)
	local result = {}
	for i = 1, #arr do
		result[arr[i][1]] = arr[i][2]
	end
	return result
end

return fromentries
