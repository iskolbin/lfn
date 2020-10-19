local function import(...)
	local libpath = select(1, ...):match(".+%.") or ""
	local result = {}
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		result[i] = require(libpath .. name)
	end
	return (_G.unpack or table.unpack)(result)
end

return import
