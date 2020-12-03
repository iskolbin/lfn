local function flatmap(arr, f)
	local result = {}
	for i = 1, #arr do
		local t = f(arr[i], i, arr)
		for j = 1, #t do
			result[#result+1] = t[j]
		end
	end
	return result
end

return flatmap
