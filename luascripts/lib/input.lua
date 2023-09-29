Input = { }
Input.__index = Input

function Input:handle_player_click(zapper, memory, Board, current_piece)
	local piece_type, board_x, board_y, piece_index = Board:get_piece_from(memory, zapper.x, zapper.y)
	if piece_type ~= 0 then
		current_piece.index = piece_index
		current_piece.type = piece_type
		current_piece.x = board_x
		current_piece.y = board_y
	else
		if Board:can_move_piece_to(true, current_piece.type, current_piece.x, current_piece.y, board_x, board_y) then
			local global_x = bit.lshift(bit.rshift(zapper.y, 3), 3) - 1
			local global_y = bit.lshift(bit.rshift(zapper.x, 3), 3)
			Board:move_piece_to(memory, current_piece.index-1, global_y, global_x)
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

return Input
