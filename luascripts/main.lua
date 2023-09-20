require 'lib/mem_addr'

-- print(string.format("0x%x", memory.readbyte(MEMORY.board.player.x)))
-- memory.writebyte(MEMORY.board.player.x, bit.band(0x58))
-- print(string.format("0x%x", memory.readbyte(MEMORY.board.player.x)))

local test_input = {
	right = true,

}
local inputs = {
	{ right = true },
	{ left = true },
	{ up = true },
	{ down = true },
}

local x = memory.readbyte(MEMORY.board.player.x)
while(true) do
	-- p1_input = math.random(4)
	-- joypad.set(1, inputs[p1_input])
	p2_input = math.random(4)
	joypad.set(2, inputs[p2_input])
	print("joypad2", joypad.readdown(2))
	-- x = x + 8
	-- memory.writebyte(MEMORY.board.player.x, x)
	-- gui.text(50, 50, "Hello world")
	emu.frameadvance()
end
