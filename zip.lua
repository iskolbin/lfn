local function zip(arr, ...)
	local n = select("#", ...) + 1
	if n == 1 then
		return arr
	else
		local result, lists = {}, {arr, ...}
		for i = 1, #lists[1] do
			local zipped = {}
			for j = 1, n do
				zipped[j] = lists[j][i]
			end
			result[i] = zipped
		end
		return result
	end
end

return zip
