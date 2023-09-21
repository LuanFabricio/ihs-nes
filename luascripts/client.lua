local socket = require'socket'

local host = 'localhost'
local port = 8080

local s = assert(socket.connect(host, port))

local player, _ = s:receive()
print("player: ", player)

local l, e
while not e do
	assert(s:send("teste\n"))
	l, e = s:receive()
	-- print("l: ", l)
end
