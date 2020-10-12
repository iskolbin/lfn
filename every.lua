local function every(arr, p)
	for i = 1, #arr do
		if not p(arr[i], i, arr) then
			return false
		end
	end
	return true
end

return every
