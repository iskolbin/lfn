local function unique(arr)
	local result, uniq, j = {}, {}, 0
	for i = 1, #arr do
		local v = arr[i]
		if not uniq[v] then
			j = j + 1
			uniq[v] = true
			result[j] = v
		end
	end
	return result
end

return unique
