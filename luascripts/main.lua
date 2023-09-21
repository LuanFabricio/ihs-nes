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

-- local x = memory.readbyte(MEMORY.board.player.x)

local p_input = math.random(4)
while(true) do
	joypad.set(1, inputs[p_input])
	p_input = math.random(4)
	joypad.set(2, inputs[p_input])
	p_input = math.random(4)
	-- print("joypad2", joypad.readdown(2))
	-- gui.text(50, 50, "Hello world")
	emu.frameadvance()
end
