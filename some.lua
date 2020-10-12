local function some(arr, p)
	for i = 1, #arr do
		if p(arr[i], i, arr) then
			return true
		end
	end
	return false
end

return some
