local pairs = _G.pairs

local function values(arr)
	local result, i = {}, 0
	for _, v in pairs(arr) do
		i = i + 1
		result[i] = v
	end
	return result
end

return values
