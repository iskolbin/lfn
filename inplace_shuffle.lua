local function shuffle(arr, rand)
	rand = rand or math.random
	for i = #arr, 1, -1 do
		local j = rand(1, i)
		arr[j], arr[i] = arr[i], arr[j]
	end
	return arr
end

return shuffle
