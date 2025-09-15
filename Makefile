test:
	lua test.lua

check:
	luacheck *.lua

cov:
	lua -lluacov test.lua
	luacov
