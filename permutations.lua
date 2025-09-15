local libpath = select(1, ...):match(".+%.") or ""
local copyarray = require(libpath .. "copyarray")

local function permute(k, buffer, result)
	if k == 1 then
		result[#result + 1] = copyarray(buffer)
	else
		permute(k - 1, buffer, result)
		for i = 1, k - 1 do
			if k % 2 == 0 then
				buffer[i], buffer[k] = buffer[k], buffer[i]
			else
				buffer[1], buffer[k] = buffer[k], buffer[1]
			end
			permute(k - 1, buffer, result)
		end
	end
	return result
end

local function permutations(array)
	return permute(#array, copyarray(array), {})
end

return permutations
