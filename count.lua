local pairs = _G.pairs

local function count(tbl, p)
	local n = 0
	if not p then
		for _ in pairs(tbl) do
			n = n + 1
		end
	else
		for k, v in pairs(tbl) do
			if p(v, k, tbl) then
				n = n + 1
			end
		end
	end
	return n
end

return count
