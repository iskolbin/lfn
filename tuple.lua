local ninterned = {}

local function tuple(...)
	local n = select("#", ...)
	if n == 0 then
		return
	end
	local interned = ninterned[n]
	if not interned then
		interned = {}
		ninterned[n] = interned
	end
	local z, zpred = interned, interned
	for i = 1, n - 1 do
		local a = select(i, ...)
		z = z[a]
		if not z then
			zpred[a] = {} --setmetatable({}, {__mode = "k"})
			z = zpred[a]
		end
		zpred = z
	end
	local an = select(n, ...)
	local res = z[an]
	if z[an] == nil then
		res = { ... }
		z[an] = res
		--print("CREATED")
	end
	return res
end

local function printdeep(t, n)
	if type(t) == "table" then
		for k, v in pairs(t) do
			print((" "):rep(n or 0) .. tostring(k) .. "=>" .. tostring(v))
			printdeep(v, (n or 0) + 1)
		end
	end
end

local x = tuple(1, 2)
tuple(3, 1)
tuple(3, 3)
tuple(3, 3)
tuple(3, 1, 2)
tuple(3, 1, 3)
tuple(3, 1, 4)
printdeep(ninterned)
tuple(3, 1, 2, 1)
tuple(3, 1, 3, 2)
tuple(3, 1, 4, 3)
tuple(3, 1, 2, 1)
tuple(3, 1, 3, 2)
local v = tuple(3, 1, 4, 3)
print()
collectgarbage()
printdeep(ninterned)
local y = tuple(1, 2)
print(x, y)
collectgarbage()
tuple(1, 2)
tuple(1, 2)

tuple(3, 1)
tuple(3, 3)
local zz = tuple(3, 1, 4, 3)
print(v, zz, v == zz)
return tuple
