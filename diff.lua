local type, pairs, next = _G.type, _G.pairs, _G.next

local libpath = select(1, ...):match(".+%.") or ""

local DEL = require(libpath .. "internal").DEL

local function dodiff(tbl1, tbl2, result, delval)
	if tbl1 ~= tbl2 then
		if type(tbl2) == "table" and type(tbl1) == "table" then
			for k, dv in pairs(tbl2) do
				local v = tbl1[k]
				if v == nil then
					result[k] = dv
				elseif v ~= dv then
					result[k] = dodiff(v, dv, {}, delval)
				end
			end
			for k in pairs(tbl1) do
				if tbl2[k] == nil then
					result[k] = delval
				end
			end
			if next(result) then
				return result
			end
		else
			return tbl2
		end
	end
end

local function diff(tbl1, tbl2, delval)
	if type(tbl1) == "table" and type(tbl2) == "table" then
		return dodiff(tbl1, tbl2, {}, delval or DEL) or {}
	else
		return tbl2
	end
end

return diff
