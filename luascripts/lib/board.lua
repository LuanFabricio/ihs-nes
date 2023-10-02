require "lib/mem_addr"
require "lib/constants"

if bit == nil then
	bit = require("bit")
end

local function knight_variations()
	local variations = { {-1, 2}, {1, 2}, {2, -1}, {2, 1}, {1, -2}, {-1, -2}, {-2, 1}, { -2, -1} }

	return variations
end

local function add_player_pawn_moves(Board, avaliable_positions, piece_x, piece_y)
	if Board.board[piece_y - 1][piece_x] ~= nil then
		table.remove(avaliable_positions, 1)
	end

	if Board.board[piece_y - 1][piece_x + 1] ~= nil then
		table.insert(avaliable_positions, { piece_x + 1, piece_y - 1 })
	end

	if Board.board[piece_y - 1][piece_x - 1] ~= nil then
		table.insert(avaliable_positions, { piece_x - 1, piece_y - 1 })
	end

	if piece_y == 7 then
		table.insert(avaliable_positions, { piece_x, piece_y - 2 })
	end
end

local function add_bot_pawn_moves(Board, avaliable_positions, piece_x, piece_y)
	if Board.board[piece_y + 1][piece_x + 1] ~= nil then
		table.insert(avaliable_positions, { piece_x + 1, piece_y + 1 })
	end

	if Board.board[piece_y + 1][piece_x - 1] ~= nil then
		table.insert(avaliable_positions, { piece_x - 1, piece_y + 1 })
	end

	if Board.board[piece_y + 1][piece_x] ~= nil then
		table.remove(avaliable_positions, 1)
	end

	if piece_y == 2 then
		table.insert(avaliable_positions, { piece_x, piece_y + 2 })
	end
end

local function pawn_variations(is_player)
	local variations = { {0, -1} }

	if not is_player then
		variations = { {0, 1} }
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

local function get_piece_addr(piece_index)
	return MEMORY.board.pieces_start + piece_index * 4
end

Board = {
	is_player_turn = true,
	board = nil,
}
Board.__index = Board

function Board:init_board(memory)
	local black_pieces = {
		{ x = 1, y = 1, type = 4, },
		{ x = 2, y = 1, type = 3, },
		{ x = 3, y = 1, type = 2, },
		{ x = 4, y = 1, type = 5, },
		{ x = 5, y = 1, type = 6, },
		{ x = 6, y = 1, type = 2, },
		{ x = 7, y = 1, type = 3, },
		{ x = 8, y = 1, type = 4, },
		{ x = 1, y = 2, type = 1, },
		{ x = 2, y = 2, type = 1, },
		{ x = 3, y = 2, type = 1, },
		{ x = 4, y = 2, type = 1, },
		{ x = 5, y = 2, type = 1, },
		{ x = 6, y = 2, type = 1, },
		{ x = 7, y = 2, type = 1, },
		{ x = 8, y = 2, type = 1, },
	}

	local current_piece_address = MEMORY.board.pieces_start

	for i=1, #black_pieces, 1 do
		local y = bit.lshift(black_pieces[i].y - 1, 3) + CONSTANTS.Y_PADDING
		local x = bit.lshift(black_pieces[i].x - 1, 3) + CONSTANTS.X_PADDING
		Board:move_piece_to(memory, i - 1, x, y)

		current_piece_address = current_piece_address + 1
		memory.writebyte(current_piece_address, black_pieces[i].type)
		current_piece_address = current_piece_address + 1
		memory.writebyte(current_piece_address, 0x01)
		current_piece_address = current_piece_address + 2
	end

	local white_pieces = {
		{ x = 1, y = 8, type = 4, },
		{ x = 2, y = 8, type = 3, },
		{ x = 3, y = 8, type = 2, },
		{ x = 4, y = 8, type = 5, },
		{ x = 5, y = 8, type = 6, },
		{ x = 6, y = 8, type = 2, },
		{ x = 7, y = 8, type = 3, },
		{ x = 8, y = 8, type = 4, },
		{ x = 1, y = 7, type = 1, },
		{ x = 2, y = 7, type = 1, },
		{ x = 3, y = 7, type = 1, },
		{ x = 4, y = 7, type = 1, },
		{ x = 5, y = 7, type = 1, },
		{ x = 6, y = 7, type = 1, },
		{ x = 7, y = 7, type = 1, },
		{ x = 8, y = 7, type = 1, },
	}

	for i=1, #white_pieces, 1 do
		local y = bit.lshift(white_pieces[i].y - 1, 3) + CONSTANTS.Y_PADDING
		local x = bit.lshift(white_pieces[i].x - 1, 3) + CONSTANTS.X_PADDING
		Board:move_piece_to(memory, #black_pieces + i - 1, x, y)

		current_piece_address = current_piece_address + 1
		memory.writebyte(current_piece_address, white_pieces[i].type)
		current_piece_address = current_piece_address + 1
		memory.writebyte(current_piece_address, 0x03)
		current_piece_address = current_piece_address + 2
	end

	Board.pieces_len = #black_pieces + #white_pieces
end

function Board:move_piece_to(memory, piece_index, x, y)
	assert(piece_index >= 0, "piece_index = " .. piece_index)
	local piece_mem = get_piece_addr(piece_index)

	memory.writebyte(piece_mem, y)
	memory.writebyte(piece_mem + 3, x)

	local piece_type = memory.readbyte(piece_mem + 1)
	local is_player = bit.band(memory.readbyte(piece_mem + 2), 3) == 3
	local board_y = bit.rshift(y - CONSTANTS.Y_PADDING, 3) + 1

	if piece_type == 1 then
			if is_player and board_y == 1 then
				memory.writebyte(piece_mem + 1, 5)
			else if board_y == 8 then
				memory.writebyte(piece_mem + 1, 5)
			end
		end
	end
end

function Board:set_piece_attribute(memory, piece_index, attribute_byte)
	local piece_mem = get_piece_addr(piece_index)

	memory.writebyte(piece_mem + 2, attribute_byte)
end

function Board:can_move_piece_to(is_player, piece_type, piece_x, piece_y, target_x, target_y)
	local is_valid_type = piece_type > 6 or piece_type <= 0
	if is_valid_type or Board.is_player_turn ~= is_player then
		return false
	end

	local moves_table = {
		[1] = pawn_variations,
		[2] = bishop_variations,
		[3] = knight_variations,
		[4] = rook_variations,
		[5] = queen_variations,
		[6] = king_variations,
	}

	local list_variations = moves_table[piece_type](is_player)
	local avaliable_positions = get_avaliable_positions(list_variations, piece_x, piece_y)

	if is_player and piece_type == 1 then
		add_player_pawn_moves(Board, avaliable_positions, piece_x, piece_y)
	else if piece_type == 1 then
			add_bot_pawn_moves(Board, avaliable_positions, piece_x, piece_y)
		end
	end

	for i = 1, #avaliable_positions, 1 do
		local current_move_x = avaliable_positions[i][1]
		local current_move_y = avaliable_positions[i][2]
		if current_move_x == target_x and current_move_y == target_y then
			Board.is_player_turn = false
			return true
		end
	end

	return false
end

function Board:check_king(is_player)
	local piece_addr = MEMORY.board.pieces_start
	for _ = 1, Board.pieces_len, 1 do
		piece_addr = piece_addr + 1
		local is_king = memory.readbyte(piece_addr) == 6
		piece_addr = piece_addr + 1
		local is_player_piece = bit.band(memory.readbyte(piece_addr), 0x03) == 0x03
		piece_addr = piece_addr + 2

		if is_king and is_player_piece == is_player then
			return true
		end
	end

	return false
end

function Board:AI_move(memory)
	-- .. do something
	Board.copy_in_game_board(Board, memory)
	Board.save_memory_board(Board)
	local handle = io.popen("cd ../ai; python ai.py")
	assert(handle ~= nil)
	local result = handle:read("*a")
	print("run AI: ", result)
	handle:close()

	-- os.execute("cd ../ai; cat chess.out")

	local move = ""
	local run_ai = "cd ../ai; cat chess.out"
	local handle = io.popen(run_ai)
	if handle ~= nil then
		-- TODO: lidar com o movimento claim_draw
		local result = handle:read("*a")
		print("AI move: ", result)
		Board:move_in_board_piece_to(memory, result:sub(1, 2), result:sub(3, 4))
		handle:close()
		Board:copy_in_game_board(memory)
		move = "(" .. result:sub(1, 1) ..  ", " .. result:sub(2, 2) .. ")"
		move = move .. " -> "
		move = move .. "(" .. result:sub(3, 3) ..  ", " .. result:sub(4, 4) .. ")"
	end
	Board.is_player_turn = true
	return move
end

function Board:count_pieces(memory)
	local pieces_len = 0
	local current_address = MEMORY.board.pieces_start

	local is_valid_piece = memory.readbyte(current_address) ~= 0 and memory.readbyte(current_address + 1) ~= 0 and memory.readbyte(current_address + 2) ~= 0 and memory.readbyte(current_address + 3) ~= 0

	while is_valid_piece do
		current_address = current_address + 4
		pieces_len = pieces_len + 1

		is_valid_piece = memory.readbyte(current_address) ~= 0 and memory.readbyte(current_address + 1) ~= 0 and memory.readbyte(current_address + 2) ~= 0 and memory.readbyte(current_address + 3) ~= 0
	end

	return pieces_len
end

function Board:copy_in_game_board(memory)
	-- print("copy_in_game_board: ", Board.pieces_len)

	-- print("piece_len: ", Board.pieces_len)
	local piece_addr = MEMORY.board.pieces_start

	Board.board = {
		{}, {}, {}, {}, {}, {}, {}, {},
	}

	for _=1, Board.pieces_len, 1 do
		local y = memory.readbyte(piece_addr)
		piece_addr = piece_addr + 1
		local piece_type = memory.readbyte(piece_addr)
		piece_addr = piece_addr + 1
		local color = bit.band(memory.readbyte(piece_addr), 0x03)
		piece_addr = piece_addr + 1
		local x = memory.readbyte(piece_addr)
		piece_addr = piece_addr + 1

		local board_x = bit.rshift(x - CONSTANTS.X_PADDING, 3) + 1
		local board_y = bit.rshift(y - CONSTANTS.Y_PADDING, 3) + 1
		local color_index = bit.rshift(color, 1) + 1
		-- print(x, y)
		-- print(board_x, board_y)
		if piece_type >= 1 and piece_type <= 6 then
			Board.board[board_y][board_x] = { piece_type, color_index }
		end
	end

	-- print("result=", Board.board)
end

function Board:save_memory_board()
	local conversion_table = {
		[1] = { "p", "P" },
		[2] = { "b", "B" },
		[3] = { "n", "N" },
		[4] = { "r", "R" },
		[5] = { "q", "Q" },
		[6] = { "k", "K" },
	}
	local file_string = ""
	for i=1, 8, 1 do
		local empty = 0
		for j=1, 8, 1 do
			local piece_set = Board.board[i][j]
			if piece_set == nil then
				empty = empty + 1
			else
				if empty > 0 then
					file_string = file_string ..empty
					empty = 0
				end
				-- print("piece_set: ", piece_set)
				file_string = file_string .. conversion_table[piece_set[1]][piece_set[2]]
			end
		end
		if empty > 0 then
			file_string = file_string .. empty
		end
		if i ~= 8 then
			file_string = file_string .. "/"
		end
	end

	local filename = "../ai/board.in"
	local file = io.open(filename, "w")
	io.output(file)
	io.write(file_string)
	io.close(file)
	print(file_string)
end

function Board:move_in_board_piece_to(memory, from, to)
	-- change board position to global position
	local from_x = tonumber(from:sub(1, 1)) - 1
	-- from_x << 3 + padding to (1, _)
	from_x = bit.lshift(from_x, 3) + CONSTANTS.X_PADDING
	local from_y = tonumber(from:sub(2, 2)) - 1
	-- from_y << 3 + padding to (_, 1)
	from_y = bit.lshift(from_y, 3) + CONSTANTS.Y_PADDING

	-- find piece index
	local _, _, _, index = Board:get_piece_from(memory, from_x, from_y)

	local to_x = tonumber(to:sub(1, 1)) - 1
	to_x = bit.lshift(to_x, 3) + CONSTANTS.X_PADDING
	local to_y = tonumber(to:sub(2, 2)) - 1
	to_y = bit.lshift(to_y, 3) + CONSTANTS.Y_PADDING

	local _, _, _, other_piece_index = Board:get_piece_from(memory, to_x, to_y)

	Board:move_piece_to(memory, index - 1, to_x, to_y)

	if other_piece_index ~= 0 then
		Board:kill_piece(memory, other_piece_index-1, Board.pieces_len)
	end
end

function Board:kill_piece(memory, index, pieces_len)
	local piece_addr = get_piece_addr(index)
	local last_piece_addr = get_piece_addr(pieces_len-1)

	Board.pieces_len = Board.pieces_len - 1

	if index == pieces_len-1 then
		for _ = 1, 4, 1 do
			memory.writebyte(last_piece_addr, 0x00)
			last_piece_addr = last_piece_addr + 1
		end
		return
	end

	-- swap last_position and index_piece
	for _=1, 4, 1 do
		local last_piece = memory.readbyte(last_piece_addr)
		memory.writebyte(piece_addr, last_piece)
		-- the memory api have some delay to execute
		while memory.readbyte(piece_addr) ~= last_piece do
		end
		memory.writebyte(last_piece_addr, 0x00)
		while memory.readbyte(last_piece_addr) ~= 0x00 do
		end
		last_piece_addr = last_piece_addr + 1
		piece_addr = piece_addr + 1
	end
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

	local hint_addres = MEMORY.board.pieces_start + Board.pieces_len * 4

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
	local i = MEMORY.board.pieces_start + Board.pieces_len * 4
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
	local board_x = bit.rshift(x - CONSTANTS.X_PADDING, 3) + 1
	local board_y = bit.rshift(y - CONSTANTS.Y_PADDING, 3) + 1

	SIZE = 8
	local piece_addr = MEMORY.board.pieces_start

	local i = 1
	for _ = 1, Board.pieces_len, 1 do
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
			board_x = bit.rshift(piece_x - CONSTANTS.X_PADDING, 3) + 1
			board_y = bit.rshift(piece_y - CONSTANTS.Y_PADDING, 3) + 1
			break
		end
		i = i + 1
	end
	if piece_type == 0 then
		i = 0
	end

	return piece_type, board_x, board_y, i
end

-- exporting Board class
return Board
