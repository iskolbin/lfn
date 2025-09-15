local pack = table.pack or function(...)
	local t = { ... }
	t.n = select("#", ...)
	return t
end

return pack
