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

local board = require 'lib.board'
local input = require 'lib.input'

local current_piece = {
	index = 0,
	type = 0,
	x = 0,
	y = 0,
}

-- board:draw_possible_moves(memory, false, 1, 1, 1)
-- board:draw_possible_moves(memory, false, 1, 3, 3)
-- board:draw_possible_moves(memory, true, 1, 3, 3)
-- board:draw_possible_moves(memory, true, 4, 4, 6)

-- os.execute("cd ../ai; cat chess.out")

-- local run_ai = "cd ../ai; cat chess.out"
-- local handle = io.popen(run_ai)
-- local result = handle:read("*a")
-- handle:close()
-- print(result)
-- Board:move_in_board_piece_to(memory, result:sub(1, 2), result:sub(3, 4))
-- Board.copy_in_game_board()

-- local p_input = math.random(4)
while(true) do
	local zapper_info = zapper.read()

	if not Board.is_player_turn then
		Board:AI_move(memory)
	else if zapper_info.fire == 1 then
			current_piece = Input:handle_player_click(zapper_info, memory, board, current_piece)
		end
	end

	emu.frameadvance()
end
