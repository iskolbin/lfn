local function deepcopy(v, buffer)
	if type(v) ~= "table" then
		return v
	end
	buffer = buffer or {}
	local result = buffer[v]
	if not result then
		result = {}
		buffer[v] = result
		for k, w in pairs(v) do
			result[deepcopy(k, buffer)] = deepcopy(w, buffer)
		end
	end
	return result
end

return deepcopy
