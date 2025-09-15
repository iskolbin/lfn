local function at(arr, i)
	if i < 0 then
		i = #arr + 1 + i
	end
	return arr[i]
end

return at
