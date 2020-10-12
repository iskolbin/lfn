local function chars(str, pattern)
	local result, i = {}, 0
	for char in str:gmatch(pattern or ".") do
		i = i + 1
		result[i] = char
	end
	return result
end

return chars
