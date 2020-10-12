local function range(init, limit, step)
	local array = {}
	if not limit then
		if not init or init == 0 then
			return array
		end
		init, limit = init > 0 and 1 or -1, init
	end
	if not step then
		step = init < limit and 1 or -1
	end
	local j = 0
	for i = init, limit, step do
		j = j + 1
		array[j] = i
	end
	return array
end

return range
