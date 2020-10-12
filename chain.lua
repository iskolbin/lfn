local type, pairs, unpack = _G.type, _G.pairs, _G.unpack or table.unpack

local libpath = select(1, ...):match(".+%.") or ""

local fn = require(libpath .. "fn")

local chainfn = {
	value = function(self)
		return unpack(self)
	end
}

for k, f in pairs(fn) do
	chainfn[k] = function(self, ...)
		self[1], self[2] = f(self[1], ...)
		if type(self[1]) ~= "table" then
			return self[1], self[2]
		else
			return self
		end
	end
end

local chainmt = {__index = chainfn}

local function chain(self)
	return setmetatable({self}, chainmt)
end

return chain
