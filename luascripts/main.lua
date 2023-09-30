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

require 'lib.board'
require 'lib.input'

local current_piece = {
	index = 0,
	type = 0,
	x = 0,
	y = 0,
}

Board:init_board(memory)
Board:copy_in_game_board(memory)

while(true) do
	if not Board:check_king(false) then
		print("PLAYER WINS!")
		break
	else
		if not Board:check_king(true) then
			print("AI WINS!")
			break
		end
	end

	local zapper_info = zapper.read()

	if not Board.is_player_turn then
		Board:AI_move(memory)
	else if zapper_info.fire == 1 then
			current_piece = Input:handle_player_click(zapper_info, memory, Board, current_piece)
		end
	end

	emu.frameadvance()
end
