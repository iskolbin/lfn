local function copyarray(arr)
	local result = {}
	for i = 1, #arr do
		result[i] = arr[i]
	end
	return result
end

return copyarray
