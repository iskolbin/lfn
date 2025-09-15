local function defaultrec(arg, _, saved, _)
	return ('{"RECURSION_%d"}'):format(saved[arg])
end

local DEFAULT_OPTIONS = {
	ident = "  ",
	lsep = "\n",
	kvsep = " = ",
	rec = defaultrec,
	id = "^[%a_][%w_]*$",
}

local COMPACT_OPTIONS = {
	ident = "",
	lsep = "",
	kvsep = "=",
	rec = defaultrec,
	id = "^[%a_][%w_]*$",
}

local type, pairs, tostring, concat = _G.type, _G.pairs, _G.tostring, table.concat

local function str(arg, options, saved, level)
	local t = type(arg)
	options = options or DEFAULT_OPTIONS
	if options == "compact" then
		options = COMPACT_OPTIONS
	end
	if t == "string" then
		return ("%q"):format(arg)
	elseif t == "table" then
		saved, level = saved or { n = 0, recursive = {} }, level or 0
		if saved[arg] then
			return (options.rec or DEFAULT_OPTIONS.rec)(arg, options, saved, level)
		else
			local ident = options.ident or DEFAULT_OPTIONS.ident
			local lsep = options.lsep or DEFAULT_OPTIONS.lsep
			local kvsep = options.kvsep or DEFAULT_OPTIONS.kvsep
			saved.n = saved.n + 1
			saved[arg] = saved.n
			local ret, na = {}, #arg
			for i = 1, na do
				ret[i] = str(arg[i], options, saved, level)
			end
			local tret, nt = {}, 0
			for k, v in pairs(arg) do
				if not ret[k] then
					nt = nt + 1
					local key = k
					if type(k) ~= "string" or not k:match(options.id or DEFAULT_OPTIONS.id) then
						key = "[" .. str(k, options, saved, level + 1) .. "]"
					end
					tret[nt] = ident:rep(level + 1) .. key .. kvsep .. str(v, options, saved, level + 1)
				end
			end
			local retc, tretc = concat(ret, ","), concat(tret, "," .. lsep)
			if tretc ~= "" then
				tretc = lsep .. tretc .. lsep .. ident:rep(level) .. "}"
			else
				tretc = "}"
			end
			return ("{%s%s%s"):format(retc, retc ~= "" and tretc ~= "}" and "," or "", tretc)
		end
	else
		return tostring(arg)
	end
end

return str
