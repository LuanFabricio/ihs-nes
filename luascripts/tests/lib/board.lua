local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'

-- proxy to memory.writebyte
MEMORY_ARR = { }
memory = { }
memory.writebyte = function (address, new_value)
	MEMORY_ARR[address] = new_value
end

memory.readbyte = function (address)
	if MEMORY_ARR[address] then
		return MEMORY_ARR[address]
	end

	return 0
end


describe('move_piece_to: Should move a piece', function ()
	local piece_index
	it("Should move piece 0 to (0x42, 0x42)", function ()
		piece_index = 0
		local x, y = 0x42, 0x42

		Board:move_piece_to(memory, piece_index, x, y)

		local address = MEMORY.board.pieces_start + piece_index * 4
		local mem_y = memory.readbyte(address)
		local mem_x = memory.readbyte(address + 3)

		assert(mem_x == x)
		assert(mem_y == y)
	end)
end)

describe("set_piece_attribute", function ()
	local piece_index
	it("Should update piece attribute by address", function ()
		piece_index = 3
		local attr_byte = 0x01

		Board:set_piece_attribute(memory, piece_index, attr_byte)

		local address = MEMORY.board.pieces_start + piece_index * 4
		local mem_attr = memory.readbyte(address + 2)

		assert(mem_attr == attr_byte)
	end)
end)

describe('can_move_piece_to: Should tell if a new position isso possible to that piece', function ()
	local piece_id
	describe("Should accept the right positions to pawn's move", function ()
		-- pawn's id
		piece_id = 1
		it("Should get the right position to player's pawn", function ()
			Board.is_player_turn = true
			local is_player = true
			local pawn_x, pawn_y = 1, 7
			local new_x, new_y = 1, 5

			assert(Board:can_move_piece_to(is_player, piece_id, pawn_x, pawn_y, new_x, new_y))

			new_x, new_y = 2, 1
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, pawn_x, pawn_y, new_x, new_y))
		end)

		it("Should get the right position to Computer's pawn", function ()
			Board.is_player_turn = true
			local is_player = true
			local is_player = false
			local pawn_x, pawn_y = 1, 2
			local new_x, new_y = 1, 4

			assert(Board:can_move_piece_to(is_player, piece_id, pawn_x, pawn_y, new_x, new_y))

			new_x, new_y = 2, 2
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, pawn_x, pawn_y, new_x, new_y))
		end)
	end)

	describe("Should accept the right position to bishop", function ()
		-- bishop's id
		piece_id = 2
		it("Should get the right position to player's bishop", function ()
			Board.is_player_turn = true
			local is_player = true
			local bishop_x, bishop_y = 1, 2
			local new_x, new_y = 2, 3

			assert(Board:can_move_piece_to(is_player, piece_id, bishop_x, bishop_y, new_x, new_y))

			new_x, new_y = 2, 2
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, bishop_x, bishop_y, new_x, new_y))

		end)

		it("Should get the right position to Computer's bishop", function ()
			Board.is_player_turn = true
			local is_player = false
			local bishop_x, bishop_y = 4, 4
			local new_x, new_y = 2, 2

			assert(Board:can_move_piece_to(is_player, piece_id, bishop_x, bishop_y, new_x, new_y))

			new_x, new_y = 2, 4
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, bishop_x, bishop_y, new_x, new_y))
		end)
	end)

	describe("Should accept the right position to knight", function ()
		-- knight's id
		piece_id = 3

		it("Should get the right position to player's knight", function ()
			Board.is_player_turn = true
			local is_player = true
			local knight_x, knight_y = 4, 4
			local new_x, new_y = 3, 2

			assert(Board:can_move_piece_to(is_player, piece_id, knight_x, knight_y, new_x, new_y))

			new_x, new_y = 4, 4
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, knight_x, knight_y, new_x, new_y))
		end)

		it("Should get the right position to Computer's knight", function ()
			Board.is_player_turn = true
			local is_player = false
			local knight_x, knight_y = 5, 5
			local new_x, new_y = 3, 4

			assert(Board:can_move_piece_to(is_player, piece_id, knight_x, knight_y, new_x, new_y))

			new_x, new_y = 8, 8
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, knight_x, knight_y, new_x, new_y))
		end)
	end)

	describe("Should accept the right position to rook", function ()
		-- rook's id
		piece_id = 4

		it("Should get the right position to player's rook", function ()
			Board.is_player_turn = true
			local is_player = true
			local rook_x, rook_y = 4, 6
			local new_x, new_y = 1, 6

			assert(Board:can_move_piece_to(is_player, piece_id, rook_x, rook_y, new_x, new_y))

			new_x, new_y = 5, 5
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, rook_x, rook_y, new_x, new_y))
		end)

		it("Should get the right position to Computer's rook", function ()
			Board.is_player_turn = true
			local is_player = false
			local rook_x, rook_y = 1, 1
			local new_x, new_y = 1, 4

			assert(Board:can_move_piece_to(is_player, piece_id, rook_x, rook_y, new_x, new_y))

			new_x, new_y = 2, 3
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, rook_x, rook_y, new_x, new_y))
		end)
	end)

	describe("Should accept the right position to queen", function ()
		-- queen's id
		piece_id = 5

		it("Should get the right position to player's queen", function ()
			Board.is_player_turn = true
			local is_player = true
			local queen_x, queen_y = 4, 4
			local new_x, new_y = 2, 4

			assert(Board:can_move_piece_to(is_player, piece_id, queen_x, queen_y, new_x, new_y))

			new_x, new_y = 3, 2
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, queen_x, queen_y, new_x, new_y))
		end)

		it("Should get the right position to Computer's queen", function ()
			Board.is_player_turn = true
			local is_player = false
			local queen_x, queen_y = 1, 1
			local new_x, new_y = 2, 2

			assert(Board:can_move_piece_to(is_player, piece_id, queen_x, queen_y, new_x, new_y))

			new_x, new_y = 2, 3
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, queen_x, queen_y, new_x, new_y))
		end)
	end)

	describe("Should accept the right position to king", function ()
		-- king's id
		piece_id = 6

		it("Should get the right position to player's king", function ()
			Board.is_player_turn = true
			local is_player = true
			local king_x, king_y = 4, 4
			local new_x, new_y = 3, 3

			assert(Board:can_move_piece_to(is_player, piece_id, king_x, king_y, new_x, new_y))

			new_x, new_y = 1, 1
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, king_x, king_y, new_x, new_y))
		end)

		it("Should get the right position to Computer's king", function ()
			Board.is_player_turn = true
			local is_player = false
			local king_x, king_y = 1, 1
			local new_x, new_y = 2, 1

			assert(Board:can_move_piece_to(is_player, piece_id, king_x, king_y, new_x, new_y))

			new_x, new_y = 8, 1
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, king_x, king_y, new_x, new_y))
		end)
	end)

end)

describe("get_piece_from", function ()
	for i = 0, 4 * 64, 1 do
		MEMORY_ARR[MEMORY.board.pieces_start+i] = 0x00
	end

	it("Should return board_x and board_y when cant find a piece", function ()
		local x, y = 0x60, 0x70

		local expected_x = bit.rshift(x - CONSTANTS.X_PADDING, 3) + 1
		local expected_y = bit.rshift(y - CONSTANTS.Y_PADDING, 3) + 1

		local _, board_x, board_y, _ = Board:get_piece_from(memory, x, y)

		assert(board_x, expected_x)
		assert(board_y, expected_y)
	end)

	it("Should return piece_type, piece board_x and board_y and memory index", function ()
		local piece_type = 0x02 -- pawn
		local piece_index = 3

		-- index: 0 and postion: (1, 1)
		MEMORY_ARR[MEMORY.board.pieces_start + piece_index * 4] = CONSTANTS.X_PADDING + bit.lshift(2, 3)
		MEMORY_ARR[MEMORY.board.pieces_start + piece_index * 4 + 1] = piece_type
		MEMORY_ARR[MEMORY.board.pieces_start + piece_index * 4 + 3] = CONSTANTS.Y_PADDING + bit.lshift(2, 3)

		local x = CONSTANTS.X_PADDING + bit.lshift(2, 3) + 4
		local y = CONSTANTS.Y_PADDING + bit.lshift(2, 3) + 4

		local expected_x = bit.rshift(x - CONSTANTS.X_PADDING, 3) + 1
		local expected_y = bit.rshift(y - CONSTANTS.Y_PADDING, 3) + 1

		local type, board_x, board_y, index = Board:get_piece_from(memory, x, y)

		assert(type, piece_type)
		assert(board_x, expected_x)
		assert(board_y, expected_y)
		assert(index, piece_index)
	end)
end)

describe("kill_piece", function ()
	it("Should remove piece from memory array", function ()
		local original_piece = { 0x55, 0x05, 03, 055 }
		MEMORY_ARR = {
			[0x0200] = original_piece[1],
			[0x0201] = original_piece[2],
			[0x0202] = original_piece[3],
			[0x0203] = original_piece[4],
			[0x0204] = 0x55,
			[0x0205] = 0x05,
			[0x0206] = 0x03,
			[0x0207] = 0x6f,
		}

		Board:kill_piece(memory, 0, 2)
		local still_there = MEMORY_ARR[0x0200] == original_piece[1] and	MEMORY_ARR[0x0201] == original_piece[2] and MEMORY_ARR[0x0202] == original_piece[3] and	MEMORY_ARR[0x0203] == original_piece[4]
		assert.falsy(still_there)
	end)

	it("Should replace with the last piece", function ()
		local new_piece = { 0x55, 0x05, 03, 0x6f }
		MEMORY_ARR = {
			[0x0200] = 0x11,
			[0x0201] = 0x01,
			[0x0202] = 0x03,
			[0x0203] = 0x33,
			[0x0204] = 0x42,
			[0x0205] = 0x06,
			[0x0206] = 0x01,
			[0x0207] = 0x33,
			[0x0208] = new_piece[1],
			[0x0209] = new_piece[2],
			[0x020a] = new_piece[3],
			[0x020b] = new_piece[4],
		}

		Board:kill_piece(memory, 0, 3)

		for i=0, 3, 1 do
			assert(memory.readbyte(0x0200 + i) == new_piece[i+1])
		end

	end)

	it("Should only delete a piece when the deleted piece is the last", function ()
		local removed_piece = { 0x55, 0x05, 0x03, 0x5f }
		MEMORY_ARR = {
			[0x0200] = 0x11,
			[0x0201] = 0x01,
			[0x0202] = 0x03,
			[0x0203] = 0x33,
			[0x0204] = 0x42,
			[0x0205] = 0x06,
			[0x0206] = 0x01,
			[0x0207] = 0x33,
			[0x0208] = removed_piece[1],
			[0x0209] = removed_piece[2],
			[0x020a] = removed_piece[3],
			[0x020b] = removed_piece[4],
		}

		Board:kill_piece(memory, 2, 3)
		for i=0, 3, 1 do
			assert(memory.readbyte(0x0208 + i) == 0)
		end

	end)
end)

describe("move_in_board_piece_to", function ()
	it("Should move a piece by board position", function ()
		MEMORY_ARR = {
			-- Rook (5, 4)
			[0x0200] = CONSTANTS.Y_PADDING + 4 * 8,
			[0x0201] = 0x04,
			[0x0202] = 0x03,
			[0x0203] = CONSTANTS.X_PADDING + 5 * 8,
		}

		local expected_x, expected_y = 5, 6
		local target_string = "" .. expected_x + 1 .. "" .. expected_y + 1
		-- (5, 4) -> (5, 6)
		Board:move_in_board_piece_to(memory, "65", target_string)

		local board_y = bit.rshift(memory.readbyte(0x0200) - CONSTANTS.Y_PADDING, 3)
		local board_x = bit.rshift(memory.readbyte(0x0203) - CONSTANTS.X_PADDING, 3)

		assert(board_x == expected_x)
		assert(board_y == expected_y)
	end)
end)
