require 'lib/mem_addr'

-- print(string.format("0x%x", memory.readbyte(MEMORY.board.player.x)))
-- memory.writebyte(MEMORY.board.player.x, bit.band(0x58))
-- print(string.format("0x%x", memory.readbyte(MEMORY.board.player.x)))

local test_input = {
	right = true,

}

local x = memory.readbyte(MEMORY.board.player.x)
while(true) do
	joypad.set(1, test_input)
	-- x = x + 8
	-- memory.writebyte(MEMORY.board.player.x, x)
	-- gui.text(50, 50, "Hello world")
	emu.frameadvance()
end
