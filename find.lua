local function find(arr, p)
	for i = 1, #arr do
		if p(arr[i], i, arr) then
			return arr[i]
		end
	end
end

return find
