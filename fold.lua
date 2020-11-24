local pairs = _G.pairs

local function fold(tbl, f, acc)
	for k, v in pairs(tbl) do
		local stop
		acc, stop = f(acc, v, k, tbl)
		if stop then
			return acc
		end
	end
	return acc
end

return fold
