if bit == nil then
	bit = require("bit")
end

local function kill_if_have_another_piece(memory, Board, index)
	if index > 0 then
		Board:kill_piece(memory, index - 1, Board.pieces_len)
	end
end

Input = { }
Input.__index = Input

function Input:handle_player_click(zapper, memory, Board, current_piece)
	local piece_type, board_x, board_y, piece_index = Board:get_piece_from(memory, zapper.x, zapper.y)
	local piece_owner = bit.band(memory.readbyte(MEMORY.board.pieces_start + 4 * (piece_index - 1) + 2), 0x03)

	if piece_type ~= 0 and piece_owner == 3 then
		current_piece.index = piece_index
		current_piece.type = piece_type
		current_piece.x = board_x
		current_piece.y = board_y
	else
		if  Board:can_move_piece_to(true, current_piece.type, current_piece.x, current_piece.y, board_x, board_y) then
			local global_x = bit.lshift(bit.rshift(zapper.y, 3), 3) - 1
			local global_y = bit.lshift(bit.rshift(zapper.x, 3), 3)

			local _, _, _, index = Board:get_piece_from(memory, global_y, global_x)

			Board:move_piece_to(memory, current_piece.index-1, global_y, global_x)

			kill_if_have_another_piece(memory, Board, index)

			current_piece = {
				index = 0,
				type = 0,
				x = 0,
				y = 0,
			}
		end
	end

	return current_piece
end

function Input:handle_player_joypad(joypad, memory, Board, current_piece)
	local min_x, max_x = CONSTANTS.X_PADDING, CONSTANTS.X_PADDING + 7 * 8;
	local min_y, max_y = CONSTANTS.Y_PADDING, CONSTANTS.Y_PADDING + 7 * 8;

	local cursor_y, cursor_x = memory.readbyte(MEMORY.cursor.start), memory.readbyte(MEMORY.cursor.start + 3)

	print(cursor_x, cursor_y)

	if joypad.up and cursor_y > min_y then
		cursor_y = cursor_y - 8
	elseif joypad.down and cursor_y < max_y then
		cursor_y = cursor_y + 8
	end

	if joypad.left and cursor_x > min_x then
		cursor_x = cursor_x - 8
	elseif joypad.right and cursor_x < max_x then
		cursor_x = cursor_x + 8
	end

	memory.writebyte(MEMORY.cursor.start, cursor_y)
	memory.writebyte(MEMORY.cursor.start + 3, cursor_x)

	return current_piece
end

return Input
