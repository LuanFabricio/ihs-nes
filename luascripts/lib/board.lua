require "lib/mem_addr"

if bit == nil then
	bit = require("bit")
end

local function knight_variations()
	local variations = { {-1, 2}, {1, 2}, {2, -1}, {2, 1}, {1, -2}, {-1, -2}, {-2, 1}, { -2, -1} }

	return variations
end

local function pawn_variations(is_player)
	local variations = { {0, -1}, {0, -2} }

	if not is_player then
		variations = { {0, 1}, {0, 2} }
	end

	return variations
end

local function bishop_variations()
	local variations = { }

	for i = 1, 8, 1 do
		table.insert(variations, { i, i })
		table.insert(variations, { i, -i })
		table.insert(variations, { -i, i })
		table.insert(variations, { -i, -i })
	end

	return variations
end

local function rook_variations()
	local variations = {}

	for i = 1, 8, 1 do
		table.insert(variations, { 0, i })
		table.insert(variations, { 0, -i })
		table.insert(variations, { -i, 0 })
		table.insert(variations, { i, 0 })
	end

	return variations
end

local function queen_variations()
	local variations = {}

	for i = 1, 8, 1 do
		table.insert(variations, { i, i })
		table.insert(variations, { i, -i })
		table.insert(variations, { -i, i })
		table.insert(variations, { -i, -i })
		table.insert(variations, { 0, i })
		table.insert(variations, { 0, -i })
		table.insert(variations, { -i, 0 })
		table.insert(variations, { i, 0 })
	end

	return variations
end

local function king_variations()
	local variations = {
		{ 1, 1 }, { -1, 1 }, { -1, -1 }, { 1, -1 },
		{ 0, 1 }, { 1, 0 }, { -1, 0 }, { 0, -1 }
	}

	return variations
end

local function get_avaliable_positions(variations, x, y)
	local moves = {}
	local nx, ny

	for i = 1, #variations, 1 do
		nx = x + variations[i][1]
		ny = y + variations[i][2]

		local is_x_ok = nx >= 1 and nx <= 8
		local is_y_ok = ny >= 1 and ny <= 8

		if is_x_ok and is_y_ok then
			table.insert(moves, { nx, ny })
		end
	end

	return moves
end

Board = {}
Board.__index = Board

function Board:move_piece_to(memory, piece_index, x, y)
	local piece_mem = MEMORY.board.pieces_start + piece_index * 4;

	memory.writebyte(piece_mem, x)
	memory.writebyte(piece_mem + 3, y)
end

function Board:can_move_piece_to(is_player, piece_type, piece_x, piece_y, target_x, target_y)
	local is_valid_type = piece_type > 6 or piece_type <= 0
	if is_valid_type then
		return false
	end

	local moves_table = {
		[1] = pawn_variations,
		[2] = bishop_variations,
		[3] = knight_variations,
		[4] = rook_variations,
		[6] = king_variations,
		[5] = queen_variations,
	}

	local list_variations = moves_table[piece_type](is_player)
	local avaliable_positions = get_avaliable_positions(list_variations, piece_x, piece_y)

	for i = 1, #avaliable_positions, 1 do
		local current_move_x = avaliable_positions[i][1]
		local current_move_y = avaliable_positions[i][2]
		if current_move_x == target_x and current_move_y == target_y then
			return true
		end
	end

	return false
end

-- TODO: remover
function Board:draw_possible_moves(memory, is_player, piece_type, x, y)
	assert(piece_type <= 6 and piece_type > 0, "Erro! Wrong piece type.")

	local moves_table = {
		[1] = pawn_variations,
		[2] = bishop_variations,
		[3] = knight_variations,
		[4] = rook_variations,
		[5] = queen_variations,
		[6] = king_variations,
	}

	local list_variations = moves_table[piece_type](is_player)
	local avaliable_positions = get_avaliable_positions(list_variations, x, y)

	local hint_addres = MEMORY.board.pieces_start + MEMORY.board.pieces_len * 4

	print(avaliable_positions)

	for i = 1, #avaliable_positions, 1 do
		local current_x = avaliable_positions[i][1] - 1
		local current_y = avaliable_positions[i][2] - 1
		current_x = 0x58 + current_x * 8
		current_y = 0x47 + current_y * 8

		memory.writebyte(hint_addres, current_y)
		hint_addres = hint_addres + 1
		memory.writebyte(hint_addres, 0x10)
		hint_addres = hint_addres + 1
		memory.writebyte(hint_addres, 0x01)
		hint_addres = hint_addres + 1
		memory.writebyte(hint_addres, current_x)
		hint_addres = hint_addres + 1
	end
end

-- TODO: remover
function Board:clear_possible_moves(memory)
	local i = MEMORY.board.pieces_start + MEMORY.board.pieces_len * 4
	while memory.readbyte(i+1) ~= 0 do
		memory.writebyte(i, 0x00)
		memory.writebyte(i + 1, 0x00)
		memory.writebyte(i + 2, 0x00)
		memory.writebyte(i + 3, 0x00)
		i = i + 4
	end
end

function Board:get_piece_from(memory, x, y)
	local piece_type = 0
	local board_x = bit.rshift(x - 0x58, 3) + 1
	local board_y = bit.rshift(y - 0x47, 3) + 1

	SIZE = 8
	local piece_addr = MEMORY.board.pieces_start

	local i = 1
	for _ = 1, MEMORY.board.pieces_len, 1 do
		local piece_y = memory.readbyte(piece_addr)
		piece_addr = piece_addr + 1
		local current_piece_type = memory.readbyte(piece_addr)
		piece_addr = piece_addr + 2
		local piece_x = memory.readbyte(piece_addr)
		piece_addr = piece_addr + 1

		local is_x_ok = piece_x <= x and x < (piece_x + SIZE)
		local is_y_ok = piece_y <= y and y < (piece_y + SIZE)

		if is_x_ok and is_y_ok then
			piece_type = current_piece_type
			board_x = bit.rshift(piece_x - 0x58, 3) + 1
			board_y = bit.rshift(piece_y - 0x47, 3) + 1
			break
		end
		i = i + 1
	end

	return piece_type, board_x, board_y, i
end

-- exporting Board class
return Board
