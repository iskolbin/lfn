local type, pairs = _G.type, _G.pairs

local libpath = select(1, ...):match(".+%.") or ""

local NIL = require(libpath .. "nil")

local function dopatch(tbl1, tbl2, nilval)
	if tbl1 ~= tbl2 then
		if type(tbl2) == "table" and type(tbl1) == "table" then
			local result = {}
			for k, v in pairs(tbl1) do
				result[k] = v
			end
			for k, dv in pairs(tbl2) do
				local v = tbl1[k]
				if dv == nilval then
					result[k] = nil
				elseif v == nil then
					result[k] = dv
				elseif v ~= dv then
					result[k] = dopatch(v, dv, nilval)
				end
			end
			return result
		else
			return tbl2
		end
	end
	return tbl1
end

local function patch(tbl1, tbl2, nilval)
	if type(tbl1) == "table" and type(tbl2) == "table" then
		return dopatch(tbl1, tbl2, nilval or NIL)
	else
		return tbl1
	end
end

return patch
