local function inplace_update(tbl, k, updfn, ...)
	tbl[k] = updfn(tbl[k], k, tbl, ...)
	return tbl
end

return inplace_update
