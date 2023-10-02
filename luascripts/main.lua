require 'lib/mem_addr'

local function draw_winner_message(winner)
	local x = 100
	if winner == "PLAYER" then
		x = 88
	end
	gui.text(x, 100, winner .. " WINS!")
end

local function draw_reset_message()
	gui.text(48, 112, "Press Start to reset the game.")
end

require 'lib.board'
require 'lib.input'

local current_piece = {
	index = 0,
	type = 0,
	x = 0,
	y = 0,
}

-- Board:init_board(memory)
Board.pieces_len = Board:count_pieces(memory)
Board:copy_in_game_board(memory)
print(Board.board)

local last_ai_move = ""

while(true) do
	Board.pieces_len = Board:count_pieces(memory)
	Board:copy_in_game_board(memory)

	if joypad.read(1).start then
		Board:init_board(memory)
		last_ai_move = ""
	end

	if not Board:check_king(false) then
		print("PLAYER WINS!")
		draw_winner_message("PLAYER")
		draw_reset_message()
	elseif not Board:check_king(true) then
		print("AI WINS!")
		draw_winner_message("AI")
		draw_reset_message()
	else
		local zapper_info = zapper.read()

		if not Board.is_player_turn then
			last_ai_move = Board:AI_move(memory)
		elseif zapper_info.fire == 1 then
			current_piece = Input:handle_player_click(zapper_info, memory, Board, current_piece)
		end
	end

	gui.text(16, 16, "AI move: " .. last_ai_move)
	emu.frameadvance()
end
