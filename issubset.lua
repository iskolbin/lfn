local function issubset(tbl1, tbl2)
	for k in pairs(tbl1) do
		if tbl2[k] == nil then
			return false
		end
	end
	return true
end

return issubset
