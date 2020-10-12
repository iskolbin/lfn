local function min(arr)
	local v = arr[1]
	for i = 2, #arr do
		if v > arr[i] then
			v = arr[i]
		end
	end
	return v
end

return min
