local floor = math.floor

local function inplace_reverse(arr)
	local n = #arr
	for i = 1, floor(n / 2) do
		local t = arr[i]
		arr[i] = arr[n - i + 1]
		arr[n - i + 1] = t
	end
	return arr
end

return inplace_reverse
