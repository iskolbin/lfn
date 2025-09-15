local loadstring = _G.loadstring or _G.load

local cache = setmetatable({}, { __mode = "kv" })

local function prealloc(n)
	local t = type(n)
	assert(t == "number", "bad argument #1 to 'prealloc' (number expected, got " .. t .. ")")
	local gen = cache[n]
	if not gen then
		gen = loadstring(table.concat({ "return {", ("0,"):rep(n), "}" }))
		cache[n] = gen
	end
	return assert(gen())
end

return prealloc
