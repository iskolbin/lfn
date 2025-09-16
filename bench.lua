local fn = require("fn")

local function running_time(n, f, ...)
	local t = os.clock()
	for _ = 1, n do
		f(...)
	end
	return (os.clock() - t) / n
end

print("lambda", running_time(1e6, fn([[@+1]]), 2))
print(
	"anon fn",
	running_time(1e6, function(x)
		return x ^ 2
	end, 2)
)

local t = os.clock()
local y = 2
for _ = 1, 1e6 do
	y = y ^ 2
end
print("native", (os.clock() - t) / 1e6)

-- added to test auto inplacing
local tbl = {}
for i = 1, 10000 do
	tbl[i] = math.random()
end
print(
	"chain call",
	running_time(1e4, function()
		return fn(tbl):reverse():filter(fn([[@>0.5]])):map(fn([[@+0.25]])):shuffle():sub(10):value()
	end)
)
