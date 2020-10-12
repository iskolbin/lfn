--taken from https://github.com/1bardesign/batteries/blob/master/sort.lua

--this is based on code from Dirk Laurie and Steve Fisher,
--used under license as follows:

--[[
	Copyright © 2013 Dirk Laurie and Steve Fisher.

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.
]]

-- (modifications by Max Cahill 2018, 2020)
-- minor modifications by Ilya Kolbin 2020

local libpath = select(1, ...):match(".+%.") or ""

local prealloc = require(libpath .. "prealloc")
local floor, ceil = math.floor, math.ceil
local maxchunksize = 32

local function insertionsort(arr, first, last, less)
	for i = first + 1, last do
		local k = first
		local v = arr[i]
		for j = i, first + 1, -1 do
			if less(v, arr[j - 1]) then
				arr[j] = arr[j - 1]
			else
				k = j
				break
			end
		end
		arr[k] = v
	end
end

local function merge(arr, workspace, low, middle, high, less)
	local i, j, k = 1, middle+1, low
	for j_ = low, middle do
		workspace[i] = arr[j_]
		i = i + 1
	end
	i = 1
	while true do
		if k >= j or j > high then
			break
		end
		if less(arr[j], workspace[i])  then
			arr[k] = arr[j]
			j = j + 1
		else
			arr[k] = workspace[i]
			i = i + 1
		end
		k = k + 1
	end
	for k_ = k, j - 1 do
		arr[k_] = workspace[i]
		i = i + 1
	end
end

local function mergesort(arr, workspace, low, high, less)
	if high - low <= maxchunksize then
		insertionsort(arr, low, high, less)
	else
		local middle = floor((low + high) / 2)
		mergesort(arr, workspace, low, middle, less)
		mergesort(arr, workspace, middle + 1, high, less)
		merge(arr, workspace, low, middle, high, less)
	end
end

local function lt(a, b)
	return a < b
end

local function stablesort(arr, less)
	less = less or lt
	local n = #arr
	if n > 1 then
		assert(less(arr[1], arr[1]) == false, "invalid order function for sorting")
		local middle = ceil(n / 2)
		local workspace = prealloc(middle)
		workspace[middle] = arr[1]
		mergesort(arr, workspace, 1, n, less)
	end
	return arr
end

return stablesort
