local select = _G.select

local function chunk(arr, ...)
	local n = select("#", ...)
	if n == 0 then
		return arr
	else
		local result, t = {}, {}
		local j, k, kmodn, m = 1, 1, 1, select(1, ...)
		for i = 1, #arr do
			t[j] = arr[i]
			if j >= m then
				result[k] = t
				kmodn, k, j, t = kmodn % n + 1, k + 1, 1, {}
				m = select(kmodn, ...)
			else
				j = j + 1
			end
		end
		if j > 1 then
			result[k] = t
		end
		return result
	end
end

return chunk
