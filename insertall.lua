local select = _G.select

local function insertall(arr, pos, ...)
	local n, m = #arr, select("#", ...)
	if pos == nil then
		return arr
	end
	if m == 0 then
		return insertall(arr, -1, pos)
	else
		local result = {}
		pos = pos < 0 and n + pos + 2 or pos
		pos = pos < 0 and 1 or pos > n+1 and n+1 or pos
		for i = 1, pos-1 do result[i] = arr[i] end
		for i = 1, m do result[i+pos-1] = select(i, ...) end
		for i = pos, n do result[i+m] = arr[i] end
		return result
	end
end

return insertall
