local function product(arr, acc)
	acc = acc or 1
	for i = 1, #arr do
		acc = arr[i] * acc
	end
	return acc
end

return product
