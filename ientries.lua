local function ientries(arr)
	local result = {}
	for i = 1, #arr do
		result[i] = { i, arr[i] }
	end
	return result
end

return ientries
