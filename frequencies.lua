local function frequencies(arr)
	local result = {}
	for i = 1, #arr do
		result[arr[i]] = (result[arr[i]] or 0) + 1
	end
	return result
end

return frequencies

