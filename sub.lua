local function sub(arr, init, limit, step)
	local n = #arr
	init, limit, step = init or 1, limit or n, step or 1
	if init < 0 then
		init = n + init + 1
	end
	if limit < 0 then
		limit = n + limit + 1
	end
	init, limit = math.max(1, math.min(init, n)), math.max(1, math.min(limit, n))
	local result, j = {}, 0
	for i = init, limit, step do
		j = j + 1
		result[j] = arr[i]
	end
	return result
end

return sub
