--[[

 fn - v3.0.1 - public domain Lua functional library
 no warranty implied; use at your own risk

 author: Ilya Kolbin (iskolbin@gmail.com)
 url: github.com/iskolbin/lfn

 See documentation in README file.

 COMPATIBILITY

 Lua 5.1+, LuaJIT

 LICENSE

 See end of file for license information.

--]]


local functions = {
	"chars", "chunk", "copy", "copyarray", "count", "deepcopy", "diff", "difference", "each",
	"entries", "equal", "every", "exclude", "filter", "find", "flat", "fold", "foldl",
	"foldr", "frequencies","fromentries", "include", "indexed", "indexof", "intersection",
	"keys", "lambda", "map", "max", "min", "op", "pack", "partition", "patch", "pred",
	"product", "range", "rep", "reverse", "reversed", "shuffle", "shuffled", "some", "sorted",
	"sortedentries", "stablesort", "str", "sub", "sum", "union", "unique", "unzip", "update",
	"utf8chars", "values", "zip",
}

local isreducer = {
	count = true, equal = true, every = true, max = true, min = true, fold = true, foldl = true,
	foldr = true, product = true, some = true, str = true, sum = true, unpack = true,
}

local unpack = _G.unpack or table.unpack

local libpath = select(1, ...):match(".+%.") or ""

local fn = {
	unpack = unpack,
	concat = table.concat,
	sort = table.sort,
}

for _, name in ipairs(functions) do
	fn[name] = require(libpath .. name)
end

local chainfn = {
	value = function(self)
		return self[1]
	end
}

for k, f in pairs(fn) do
	if isreducer[k] then
		chainfn[k] = function(self, ...)
			return f(self[1], ...)
		end
	else
		chainfn[k] = function(self, ...)
			self[1], self[2] = f(self[1], ...)
			if type(self[1]) ~= "table" then
				return self[1], self[2]
			else
				return self
			end
		end
	end
end

local chainmt = {__index = chainfn}

local function chain(self)
	return setmetatable({self}, chainmt)
end

fn.chain =  chain
fn.L = fn.lambda
fn.NIL = require(libpath .. "nil")
fn._ = require(libpath .. "wild")

return setmetatable( fn, {__call = function(_, t, ...)
	local ttype = type(t)
	if ttype == "table" then
		return fn.chain(t, ...)
	elseif ttype == "string" then
		return fn.lambda(t, ...)
	elseif ttype == "number" then
		return fn.chain(fn.range(t, ...))
	else
		error("fn accepts table, string or 1,2 or 3 numbers as the arguments")
	end
end})


--[[
------------------------------------------------------------------------------
This software is available under 2 licenses -- choose whichever you prefer.
------------------------------------------------------------------------------
ALTERNATIVE A - MIT License
Copyright (c) 2018 Ilya Kolbin
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
------------------------------------------------------------------------------
ALTERNATIVE B - Public Domain (www.unlicense.org)
This is free and unencumbered software released into the public domain.
Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
software, either in source code form or as a compiled binary, for any purpose,
commercial or non-commercial, and by any means.
In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and to
the detriment of our heirs and successors. We intend this dedication to be an
overt act of relinquishment in perpetuity of all present and future rights to
this software under copyright law.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
------------------------------------------------------------------------------
--]]
