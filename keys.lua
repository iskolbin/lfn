local pairs = _G.pairs

local function keys(arr)
	local result, i = {}, 0
	for k in pairs(arr) do
		i = i + 1
		result[i] = k
	end
	return result
end

return keys
