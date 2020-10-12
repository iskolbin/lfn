local select = _G.select

local function exclude(arr, ...)
	local result, j, toremove = {}, 0, {}
	for i = 1, select("#", ...) do
		toremove[select(i, ...)] = true
	end
	for i = 1, #arr do
		local v = arr[i]
		if not toremove[v] then
			j = j + 1
			result[j] = v
		end
	end
	return result
end

return exclude
