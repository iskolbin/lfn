local loadstring = _G.loadstring or _G.load
local tonumber, max, assert, concat = _G.tonumber, math.max, _G.assert, table.concat

local cache = setmetatable({}, { __mode = "kv" })

local function lambda(code, ...)
	local curried = select("#", ...)
	local fs = cache[curried]
	local fc = fs and fs[code]
	if not fc then
		local maxarg, args = 0, {}
		local body = code:gsub("%@(%d+)", function(x)
			if tonumber(x) > maxarg then
				maxarg = tonumber(x)
			end
			return "__" .. x .. "__"
		end)
		local noindexarg
		body, noindexarg = body:gsub("%@", "__1__")
		for i = 1, max(maxarg, curried, noindexarg == 0 and 0 or 1) do
			args[#args + 1] = "__" .. i .. "__"
		end

		local curriedargs = curried > 0 and ("local %s = ...\n"):format(concat(args, ",", 1, curried)) or ""

		local gencode = ("%sreturn function(%s) return %s end"):format(
			curriedargs,
			concat(args, ",", curried + 1),
			body
		)

		fc = assert(loadstring(gencode))
		if curried == 0 then
			fc = fc()
		end
		if not fs then
			cache[curried] = { [code] = fc }
		else
			cache[curried][code] = fc
		end
	end
	if curried == 0 then
		return fc
	else
		return fc(...)
	end
end

return lambda
