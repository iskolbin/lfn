local fn = require("fn")

local function assertq(a, b)
	return assert(fn.equal(a, b), fn.str(a) .. ' ~= ' .. fn.str(b))
end

assertq(fn.inplace_filter({1,2,3,4,5}, function(x) return x > 2 end), {3,4,5})
assertq(fn{x = true, y = true, z = true}:issubset{x = true, y = true, z = true}, true)
assertq(fn{x = true, y = true}:issubset{x = true, y = true, z = true}, true)
assertq(fn{x = true, y = true, k = true}:issubset{x = true, y = true, z = true}, false)
assertq({fn.op.identity(1, 2, 3)}, {1,2,3})
assertq(fn.op.truth(), true)
assertq(fn.op.lie(), false)
assertq(fn.op.neg(33), -33)
assertq(fn.op.neg(-42), 42)
assertq(fn.op.add(33, 77), 110)
assertq(fn.op.sub(40, 20), 20)
assertq(fn.op.mul(10, 20), 200)
assertq(fn.op.div(20, 5), 4)
assertq(fn.op.idiv(23, 5), 4)
assertq(fn.op.pow(10, 3), 1000)
assertq(fn.op.inc(2), 3)
assertq(fn.op.dec(-4), -5)
assertq(fn.op.concat("Hello", " world"), "Hello world")
assertq(fn.op.gt(5, 3), true)
assertq(fn.op.gt(3, 5), false)
assertq(fn.op.gt(3, 3), false)
assertq(fn.op.ge(5, 3), true)
assertq(fn.op.ge(3, 5), false)
assertq(fn.op.ge(3, 3), true)
assertq(fn.op.lt(3, 5), true)
assertq(fn.op.lt(5, 3), false)
assertq(fn.op.lt(3, 3), false)
assertq(fn.op.le(3, 5), true)
assertq(fn.op.le(5, 3), false)
assertq(fn.op.le(3, 3), true)
assertq(fn.op.eq(3, 3), true)
assertq(fn.op.eq(3, 2), false)
assertq(fn.op.ne(3, 3), false)
assertq(fn.op.ne(3, 2), true)
assertq(fn.op.land(true, false), false)
assertq(fn.op.land(true, true),true)
assertq(fn.op.lor(true, false),true)
assertq(fn.op.lor(true, true), true)
assertq(fn.op.lnot(true), false)
assertq(fn.op.lnot(false), true)
assertq(fn.op.lxor(true, false), true)
assertq(fn.op.lxor(true, true), false)
assertq(fn.op.lxor(false, false), false)

assertq(fn.pred.isnil(nil), true)
assertq(fn.pred.isnil(22), false)
assertq(fn.pred.iszero(0), true)
assertq(fn.pred.iszero(2), false)
assertq(fn.pred.ispositive(22), true)
assertq(fn.pred.ispositive(-22), false)
assertq(fn.pred.isnegative(22), false)
assertq(fn.pred.isnegative(-22), true)
assertq(fn.pred.iseven(10), true)
assertq(fn.pred.iseven(11), false)
assertq(fn.pred.isodd(10), false)
assertq(fn.pred.isodd(11), true)
assertq(fn.pred.isnumber(5), true)
assertq(fn.pred.isnumber(3.5), true)
assertq(fn.pred.isinteger(5), true)
assertq(fn.pred.isinteger(3.5), false)
assertq(fn.pred.isinteger("3.5"), false)
assertq(fn.pred.isboolean(true), true)
assertq(fn.pred.isboolean(false), true)
assertq(fn.pred.isboolean(nil), false)
assertq(fn.pred.isboolean(11), false)
assertq(fn.pred.isstring(55), false)
assertq(fn.pred.isstring("asd"), true)
assertq(fn.pred.isfunction(function() end), true)
assertq(fn.pred.isfunction(math.sin), true)
assertq(fn.pred.isfunction(22), false)
assertq(fn.pred.istable{}, true)
assertq(fn.pred.istable(22), false)
assertq(fn.pred.isuserdata(io.tmpfile()), true)
assertq(fn.pred.isuserdata(22), false)
assertq(fn.pred.isthread(coroutine.create(function() end)), true)
assertq(fn.pred.isthread(function() end), false)
assertq(fn.pred.isid"Abacz", true)
assertq(fn.pred.isid"zzz123", true)
assertq(fn.pred.isid" Abasd", false)
assertq(fn.pred.isid"__aa", true)
assertq(fn.pred.isid"22ss", false)
assertq(fn.pred.isid"asd$", false)
assertq(fn.pred.isid"asd ", false)
assertq(fn.pred.isempty{}, true)
assertq(fn.pred.isempty{1}, false)
assertq(fn.pred.isempty{x=2}, false)

assertq(fn'55'(), 55)
assertq(fn.foldl({1,2,3,4}, fn[[@1 * @2]], 1), 24)
assertq(fn.foldr({"d","l","r","o","W"}, fn"@1..@2", ""), "World")
assertq(fn.sum{1, 2, 3, 4}, 10)
assertq(fn.sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 5), {1, 2, 3, 4, 5})
assertq(fn.sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 6, -2), {6, 7, 8, 9})
assertq(fn.sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, -4, -2), {7, 8, 9})
assertq(fn.sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 7), {7, 8, 9, 10})
assertq(fn.sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, -1), {10})
assertq(fn.sub({1, 2, 3, 4, 5}, 0), {1, 2, 3, 4, 5})
assertq(fn.inplace_sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 5), {1, 2, 3, 4, 5})
assertq(fn.inplace_sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 6, -2), {6, 7, 8, 9})
assertq(fn.inplace_sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, -4, -2), {7, 8, 9})
assertq(fn.inplace_sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 7), {7, 8, 9, 10})
assertq(fn.inplace_sub({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, -1), {10})
assertq(fn.inplace_sub({1, 2, 3, 4, 5}, 0), {1, 2, 3, 4, 5})
assertq(fn.reverse{1, 2, 3, 4, 5}, {5, 4, 3, 2, 1})
assertq(fn.insert({1, 2, 3, 4, 5}, -1, 6), {1, 2, 3, 4, 5, 6})
assertq(fn.insert({1, 2, 3, 4, 5}, 1, 0), {0, 1, 2, 3, 4, 5})
assertq(fn.insert({1, 2, 3, 4, 5}, 3, 2.5), {1, 2, 2.5, 3, 4, 5})
assertq(fn.insert({1, 2, 3, 4, 5}, -1, 6), {1, 2, 3, 4, 5, 6})
assertq(fn.insert({1, 2, 3, 4, 5}, -1, 6, 7, 8, 9, 10), {1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
assertq(fn.insert({1, 2, 3, 4, 5}, 1, 6, 7), {6, 7, 1, 2, 3, 4, 5})
assertq(fn.insert({1, 2, 3, 4, 5}, 2, 6, 7), {1, 6, 7, 2, 3, 4, 5})
assertq(fn.insert({1, 2, 3, 4, 5}, -2, 6, 7), {1, 2, 3, 4, 6, 7, 5})
assertq(fn.insert({1, 2, 3, 4, 5}, -1000, 6, 7), {6, 7, 1, 2, 3, 4, 5})
assertq(fn.insert({1, 2, 3, 4, 5}, 1000, 6, 7), {1, 2, 3, 4, 5, 6, 7})
assertq(fn.exclude({1, 2, 3, 4, 5}, 3, 4), {1, 2, 5})
assertq(fn.exclude({1, 2, 3, 4, 5}, 1, 6, 3), {2, 4, 5})
assertq(fn.inplace_exclude({1, 2, 3, 4, 5}, 3, 4), {1, 2, 5})
assertq(fn.inplace_exclude({1, 2, 3, 4, 5}, 1, 6, 3), {2, 4, 5})
assertq(fn.partition({1, 2, 3, 4, 5, 6}, fn[[@>3]]), {{4, 5, 6}, {1, 2, 3}})
assertq(fn.partition({1, 2, 3, 4, 5, 6}, fn.op.truth), {{1, 2, 3, 4, 5, 6}, {}})
assertq(fn.flat{1, 2, 3, {4, {5, {6, 7, {8}, 9}, 10}}, 11}, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
assertq(fn.flat{1, 2, 3, 4}, {1, 2, 3, 4})
assertq(fn.count({1, 2, 3, 4, 5}, fn.pred.isodd), 3)
assertq(fn.count({{1}, {2}, {3}}, fn[[@[1]>2]]), 1)
assertq(fn.every({1, 2, 3, "t"}, fn.pred.isinteger), false)
assertq(fn.every({1, 2, 3, 5}, fn.pred.isinteger), true)
assertq(fn.some({1, 2, 3, "t", {}}, fn.pred.istable), true)
assertq(fn.some({1, 2, 3, 5}, fn.pred.istable), false)
assertq(fn.filter({10, 20, 30, 40, 50}, fn[[@>30]]), {40, 50})
assertq(fn.filter({10, 20, 30, 40, 50}, fn[[@2<5 and @1>30]]), {40})
assertq(fn.filter({10, 20, 3, 40, 50}, fn[[@3[@2] == @2]]), {3})
assertq(fn.inplace_filter({10, 20, 30, 40, 50}, fn[[@>30]]), {40, 50})
assertq(fn.inplace_filter({10, 20, 30, 40, 50}, fn[[@2<5 and @1>30]]), {40})
assertq(fn.inplace_filter({10, 20, 3, 40, 50}, fn[[@3[@2] == @2]]), {3})
assertq(fn.map({1, 2, 3, 4, 5}, fn.op.inc), {2, 3, 4, 5, 6})
assertq(fn.map({2, 3, 4, 5, 6}, fn[[(@2 > 3) and 2*@1 or -@1]]), {-2, -3, -4, 10, 12})
assertq(fn.inplace_map({1, 2, 3, 4, 5}, fn.op.inc), {2, 3, 4, 5, 6})
assertq(fn.inplace_map({2, 3, 4, 5, 6}, fn[[(@2 > 3) and 2*@1 or -@1]]), {-2, -3, -4, 10, 12})
assertq(fn.sort{1, 2, 4, 5, 2, 3, -1}, {-1, 1, 2, 2, 3, 4, 5})
assertq(fn.sort({1, 2, 4, 5, 2, 3, -1}, fn.op.gt), {5, 4, 3, 2, 2, 1, -1})
assertq(fn.sort(fn.keys{x = 2, y = 3}), {"x", "y"})
assertq(fn.keys{1, 2, 4, 7}, {1, 2, 3, 4})
assertq(fn.sort(fn.values{x = 2, y = 3}), {2, 3})
assertq(fn.values{1, 2, 3, 5}, {1, 2, 3, 5})
assertq(fn.copy{1, 2, 3, x=5, z={1, 2}}, {1, 2, 3, x=5, z={1, 2}})
local t = {}
t[1] = t
local t_c = fn.deepcopy(t)
assert(t_c ~= t)
assert(t_c[1] == t_c)
assertq(fn.copy{1, 2, 3, x=5, z={1, 2}}, {1, 2, 3, x=5, z={1, 2}})
assertq(fn.indexof({1, 2, "x", 4, 5, 6}, "x"), 3)
assertq(fn.indexof({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 7, fn.lt), 7)
assertq(fn.indexof({10, 9, 8, 7, 6, 5, 4, 3, 2, 1}, 7, fn.gt), 4)
assertq(fn.find({"x", "y", "z", "aa", "b", "c"}, fn[[@ == "aa"]]), "aa")
assertq(fn.find({{1}, {2}, {3}, {4}}, fn"@[1] == 3"), {3})
assertq(fn.indexed{2, 3, 4}, {{1, 2}, {2, 3}, {3, 4}})
assertq(fn.sort(fn.entries{x = 2, y = 3, z = 4}, fn"@1[1] < @2[1]"), {{"x", 2}, {"y", 3}, {"z", 4}})
assertq(fn.fromentries{{"x", 2}, {"y", 3}, {"z", 4}}, {x = 2, y = 3, z = 4})
assertq(fn.update({x = 2, y = 3, z = 4}, {z = 5}), {x = 2, y = 3, z = 5})
assertq(fn.update({x = 2, y = 3, z = 4}, {x = 3, a = 3, z = fn.NIL}), {x = 3, a = 3, y = 3})
assertq(fn.unique{1, 2, 3, 1, 2, 3, 1, 4, 5}, {1, 2, 3, 4, 5})
assertq(fn.count{x = 2, y = 3}, 2)
assertq(fn.count{x = 3, y = 3, 1, 2}, 4)
assertq(fn.range(0), {})
assertq(fn.range(-1), {-1})
assertq(fn.range(1, 5, -1), {})
assertq(fn.range(-1, -5, 1), {})
assertq(fn.range(-1, -5), {-1, -2, -3, -4, -5})
assertq(fn.range(5), {1, 2, 3, 4, 5})
assertq(fn.range(2, 5), {2, 3, 4, 5})
assertq(fn.range(5, 1), {5, 4, 3, 2, 1})
assertq(fn.range(1, 6, 2), {1, 3, 5})
assertq(fn.range(5, 2, -2), {5, 3})
assertq(fn.sortedentries{x = 2, z = 3, y = 6}, {{"x", 2},{"y", 6},{"z", 3}})
assertq(fn.sortedentries({[{"x"}] = 2, [{"z"}] = 3, [{"y"}] = 6}, fn[[@1[1]<@2[1] ]]),
	{{{"x"},2},{{"y"},6},{{"z"},3}})
assertq(fn.concat(fn.reverse(fn.chars"Baroque")), ("Baroque"):reverse())
assertq(fn.concat(fn.reverse(fn.utf8chars"Шаломчик")), "кичмолаШ")
assertq(#(fn.utf8chars"Вариация"), 8)
assertq(#(fn.chars"Вариация"), string.len("Вариация"))
assertq(fn{1, 2, 3}:rep(3):value(), {1, 2, 3, 1, 2, 3, 1, 2, 3})
assertq(fn{1, 2, 3}:rep(3, "x"):value(), {1, 2, 3, "x", 1, 2, 3, "x", 1, 2, 3})
assertq(fn{1, 2, 3, 4}:zip():value(), {1, 2, 3, 4})
assertq(fn{}:zip():value(), {})
assertq(fn.zip({1, 2}, {"x", "y"}, {55.55, 66.66}), {{1, "x", 55.55}, {2, "y", 66.66}})
assertq(fn.zip({1, 2}, {"x", "y", "z"}, {55.55}), {{1, "x", 55.55}, {2, "y", nil}})
assertq(fn{{1, "x", 55.55}, {2, "y", 66.66}}:unzip():value(), {{1, 2}, {"x", "y"}, {55.55, 66.66}})
assertq(fn.fromentries(fn.zip({"x", "y", "z"}, {1, 2, 3})), {x = 1, y = 2, z = 3})
assertq(fn.frequencies{ "x", "y", "z", "x", "y", "x" }, {x = 3, y = 2, z = 1})
assert(fn([[@ - 2]], 2)() == 0)
assert(fn([[@1 + @2 + @3]], 1, 2)(3) == 6)
assertq(fn{1, 2, 3, 4}:insert():value(), {1, 2, 3, 4})
assertq(fn.copy(10), 10)
assertq(fn.equal({x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = fn._}), true)
assertq(fn.equal({x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = {x = 4}}), false)
assertq(fn.equal({x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = {x = {}}}), false)
assertq(fn.equal({x = 2, y = 3, z = {x = 2}}, {x = 2, y = 4, z = {x = 2}}), false)
assertq(fn.equal({x = 2, y = 3, z = {x = 2}}, {x = 2, y = 3, z = {x = 2, u = 22}}), false)
assertq(fn.equal({[true] = 1}, {[true] = 1}), true)
assertq(fn{1, 2, 3, 4}:foldl(fn[[@1+@2, @3 == 3]], 0), 6)
assertq(fn{1, 2, 3, 4}:foldl(fn[[@+@2, @3 == 3]], 0), 6)
assertq(fn{1, 2, 3, 4}:foldr(fn[[@1+@2, @3 == 3]], 0), 7)
local x = {}
x[x] = x
assertq(x, x)
assertq(fn{1, 2, 3, 4}:chunk():value(), {1, 2, 3, 4})
assertq(fn{1, 2, 3, 4}:chunk(1):value(), {{1}, {2}, {3}, {4}})
assertq(fn{1, 2, 3, 4}:chunk(2):value(), {{1, 2}, {3, 4}})
assertq(fn{1, 2, 3, 4}:chunk(3):value(), {{1, 2, 3}, {4}})
assertq(fn{1, 2, 3, 4}:chunk(4):value(), {{1, 2, 3, 4}})
assertq(fn{1, 2, 3, 4}:chunk(1):flat():value(), {1, 2, 3, 4})
assertq(fn{1, 2, 3, 4, 5}:chunk(1, 2):value(), {{1}, {2, 3}, {4}, {5}})
assertq(fn{1, 2, 3, 4, 5, 6, 7}:chunk(1, 2, 3):value(), {{1}, {2, 3}, {4, 5, 6}, {7}})
assertq(fn{x = 5, y = 6, z = 8}:difference():value(), {x = 5, y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:difference{}:value(), {x = 5, y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:difference({x = 6}, {}):value(), {y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:difference{x = 6}:value(), {y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:difference({x = 6, k = 8}, {y = 11, a = 18}, {c = 3, x=4}):value(), {z = 8})
assertq(fn{x = 5, y = 6, z = 8}:intersection{x = 1}:value(), {x = 5})
assertq(fn{x = 5, y = 6, z = 8}:intersection():value(), {})
assertq(fn{x = 5, y = 6, z = 8}:intersection{}:value(), {})
assertq(fn{x = 5, y = 6, z = 8}:intersection({x = 1}, {y = 2}):value(), {})
assertq(fn{x = 5, y = 6, z = 8}:intersection({x = 1, y = 2}, {y = 4}):value(), {y = 6})
assertq(fn{x = 5, y = 6, z = 8}:intersection({x = 1, y = 2}, {y = 4}, {}):value(), {})
assertq(fn{x = 5, y = 6, z = 8}:union():value(), {x = 5, y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:union{}:value(), {x = 5, y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:union{x = 11}:value(), {x = 5, y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:union({x = 11}, {y = 22}):value(), {x = 5, y = 6, z = 8})
assertq(fn{x = 5, y = 6, z = 8}:union({x = 11}, {y = 22, b = 14}):value(), {b = 14, x = 5, y = 6, z = 8})
assertq(fn{x = 5}:diff{x = 5}:value(), {})
assertq(fn{x = 5}:diff{x = 6}:value(), {x = 6})
assertq(fn{x = 5}:diff{x = 5, y = 5}:value(), {y = 5})
assertq(fn{x = 5}:diff{x = 6, y = 5}:value(), {x = 6, y = 5})
assertq(fn{x = 5}:diff{y = 5}:value(), {x = fn.NIL, y = 5})
assertq(fn{x = 5}:diff{y = {z = 6}}:value(), {x = fn.NIL, y = {z = 6}})
assertq(fn{x = 5}:diff{x = {z = 6}}:value(), {x = {z = 6}})
assertq(fn.diff(5, 6), 6)
assertq(fn.diff({}, "str"), "str")
assertq(fn.diff("asd", {}), {})
assertq(fn{x = {y = 6}}:diff{x = {y = 6}}:value(), {})
assertq(fn{x = {y = 6}}:diff{x = {y = 7}}:value(), {x = {y = 7}})
assertq(fn{x = {y = 6}}:diff{x = {z = 7}}:value(), {x = {y = fn.NIL, z = 7}})
assertq(fn{x = {y = 6}}:diff{x = 5}:value(), {x = 5})
assertq(fn{x = 5}:patch{x = 5}:value(), {x = 5})
assertq(fn{x = 5}:patch{x = 6}:value(), {x = 6})
assertq(fn{x = {y = 6}}:patch{x = 6}:value(), {x = 6})
assertq(fn{x = {y = 6}, z = 55}:patch{x = {y = 5}}:value(), {x = {y = 5}, z = 55})
assertq(fn{x = 6}:patch(3):value(), {x = 6})
assertq(fn.patch("ddd", {x = 4}), "ddd")
assertq(fn.patch("ddd", 555), "ddd")
assertq(fn{x = {y = 6, z = {55}, u = 69}}:patch{x = {z = {n = 5}}}:value(), {x = {y = 6, z = {55, n = 5}, u = 69}})
assertq(fn{1, 2, 3, 4, 5, 6}:min(), 1)
assertq(fn{-1, 2, 3, 4, 5, -6}:min(), -6)
assertq(fn{-1, 2, 3, 4, 5, -6}:max(), 5)
assertq(fn{1, 2, 3, 4, 5, 6}:shuffle():max(), 6)
assertq(fn{3, 4, 5, 6, 7, 1}:sort(fn[[@1 > @2]]):value(), {7, 6, 5, 4, 3, 1})
assertq(fn{1,2,3}:combinations(2):value(), {{1,2},{1,3},{2,3}})
assertq(fn{1,2,3}:permutations():value(), {{1,2,3},{2,1,3},{3,1,2},{1,3,2},{2,3,1},{3,2,1}})
assertq(fn{1,2,3}:combinations(2):flatmap(fn.permutations):value(), {{1,2},{2,1},{1,3},{3,1},{2,3},{3,2}})
