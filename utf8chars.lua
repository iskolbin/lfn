local libpath = select(1, ...):match(".+%.") or ""
local chars = require(libpath .. "chars")

local UTF8_PATTERN = "([%z\1-\127\194-\244][\128-\191]*)"

local function utf8chars(str)
	return chars(str, UTF8_PATTERN)
end

return utf8chars
