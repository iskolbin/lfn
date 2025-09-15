local function cache(f)
	local c = {}
	return function(...)
		local z, zpred, n = c, c, select("#", ...)
		for i = 1, n - 1 do
			local a = select(i, ...)
			z = z[a]
			if not z then
				zpred[a] = {}
				z = zpred[a]
			end
			zpred = z
		end
		local an = select(n, ...)
		local res = z[an]
		if z[an] == nil then
			res = f(...)
			z[an] = res
		end
		return res
	end
end

return cache
