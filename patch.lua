local type, pairs = _G.type, _G.pairs

local libpath = select(1, ...):match(".+%.") or ""

local copy = require(libpath .. "copy")
local DEL = require(libpath .. "internal").DEL

local function dopatch(tbl1, tbl2, delval, inplace)
	if tbl1 == tbl2 then
		return tbl1
	end
	if type(tbl2) ~= "table" or type(tbl1) ~= "table" then
		return tbl2
	end
	local result = inplace and tbl1 or copy(tbl1)
	for k, dv in pairs(tbl2) do
		local v = tbl1[k]
		if dv == delval then
			result[k] = nil
		elseif v == nil then
			result[k] = dv
		elseif v ~= dv then
			result[k] = dopatch(v, dv, delval)
		end
	end
	return result
end

local function patch(tbl1, tbl2, delval, inplace)
	if type(tbl1) == "table" and type(tbl2) == "table" then
		return dopatch(tbl1, tbl2, delval or DEL, inplace)
	else
		return tbl1
	end
end

return patch
