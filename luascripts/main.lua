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

Board.copy_in_game_board()
Board.save_memory_board()
os.execute("cd ../ai; python ai.py")
os.execute("cd ../ai; cat chess.out")

local run_ai = "cd ../ai; cat chess.out"
local handle = io.popen(run_ai)
local result = handle:read("*a")
handle:close()
print(result)
Board:move_in_board_piece_to(memory, result:sub(1, 2), result:sub(3, 4))
Board.copy_in_game_board()

-- local p_input = math.random(4)
while(true) do
	local mouse = zapper.read()

	if not Board.is_player_turn then
		Board:AI_move()
	else if mouse.fire == 1 then
			print("CURRENT_PIECE: ", current_piece)
			print("is_player_turn: ", Board.is_player_turn)
			local piece_type, board_x, board_y, piece_index = board:get_piece_from(memory, mouse.x, mouse.y)
			if piece_type ~= 0 then
				current_piece.index = piece_index
				current_piece.type = piece_type
				current_piece.x = board_x
				current_piece.y = board_y
			else
				if Board:can_move_piece_to(true, current_piece.type, current_piece.x, current_piece.y, board_x, board_y) then
					local global_x = bit.lshift(bit.rshift(mouse.y, 3), 3) - 1
					local global_y = bit.lshift(bit.rshift(mouse.x, 3), 3)
					Board:move_piece_to(memory, current_piece.index-1, global_x, global_y)
				end
				current_piece = {
					index = 0,
					type = 0,
					x = 0,
					y = 0,
				}
			end
		end
	end

	emu.frameadvance()
end
