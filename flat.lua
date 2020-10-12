local function doflat(result, v, index, level)
	if type(v) == "table" and (level == nil or level > 0) then
		for k = 1, #v do
			index = doflat(result, v[k], index, level and (level-1))
		end
	else
		index = index + 1
		result[index] = v
	end
	return index
end

local function flat(arr, level)
	local result, j = {}, 0
	for i = 1, #arr do
		j = doflat(result, arr[i], j, level)
	end
	return result
end

return flat
