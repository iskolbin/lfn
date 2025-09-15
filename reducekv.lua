local pairs = _G.pairs

local function reducekv(tbl, f, acc)
	for k, v in pairs(tbl) do
		acc = f(acc, k, v, tbl)
	end
	return acc
end

return reducekv
