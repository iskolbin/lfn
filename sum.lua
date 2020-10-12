local function sum(arr, acc)
	acc = acc or 0
	for i = 1, #arr do
		acc = arr[i] + acc
	end
	return acc
end

return sum
