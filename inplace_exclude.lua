local select = _G.select

local function inplace_exclude(arr, ...)
	local j, toremove, n = 0, {}, #arr
	for i = 1, select("#", ...) do
		toremove[select(i, ...)] = true
	end
	for i = 1, n do
		local v = arr[i]
		if not toremove[v] then
			j = j + 1
			arr[j] = v
		end
	end
	for i = j+1, n do
		arr[i] = nil
	end
	return arr
end

return inplace_exclude
