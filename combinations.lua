local libpath = select(1, ...):match(".+%.") or ""
local copyarray = require(libpath .. "copyarray")

local function combine(array, combo_size, k, buffer, result)
	if #buffer >= combo_size then
		result[#result+1] = copyarray(buffer)
	else
		for i = k, #array do
			buffer[#buffer+1] = array[i]
			combine(array, combo_size, i + 1, buffer, result)
			buffer[#buffer] = nil
		end
	end
	return result
end

local function combinations(array, combo_size)
	return combine(array, combo_size, 1, {}, {})
end

return combinations
