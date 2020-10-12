local type, pairs, setmetatable, getmetatable = _G.type, _G.pairs, _G.setmetatable, _G.getmetatable

local function copy(val)
	if type(val) == "table" then
		local result = {}
		for k, v in pairs(val) do
			result[k] = v
		end
		return setmetatable(result, getmetatable(val))
	else
		return val
	end
end

return copy
