Socket = require"socket"

local host = "localhost"
local port = 8080

local socket = assert(Socket.bind(host, port))

local next_player = 1
local c1 = assert(socket:accept())
c1:send(next_player .. '\n')

next_player = next_player + 1
local c2 = assert(socket:accept())
c2:send(next_player .. '\n')

local l, e
while not e do
	l, e = c1:receive()
	assert(c1:send("hallo\n"))
	if e then
		break
	end
	l, e = c2:receive()
	assert(c2:send("hallo\n"))
end
print('e: ', e)
