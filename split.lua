local gmatch = string.gmatch

local function split(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local t, i = {}, 0
	for s in gmatch(str, "([^" .. sep .. "]+)") do
		i = i + 1
		t[i] = s
	end
	return t
end

return split
