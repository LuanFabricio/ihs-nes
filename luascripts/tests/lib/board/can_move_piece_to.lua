local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

describe('can_move_piece_to: Should tell if a new position isso possible to that piece', function ()
	local piece_id
	describe("Should accept the right positions to pawn's move", function ()
		-- pawn's id
		piece_id = 1
		it("Should get the right position to player's pawn", function ()
			local is_player = true
			piece_id = 1
			local pawn_x, pawn_y = 1, 7
			local new_x, new_y = 1, 5

			Board.board = {
				{}, {}, {}, {}, {}, {}, {}, {}
			}
			Board.pieces_len = 0
			Board.is_player_turn = true

			assert(Board:can_move_piece_to(is_player, piece_id, pawn_x, pawn_y, new_x, new_y))

			new_x, new_y = 2, 1

			Board.is_player_turn = true

			assert.falsy(Board:can_move_piece_to(is_player, piece_id, pawn_x, pawn_y, new_x, new_y))
		end)

		it("Should get the right position to Computer's pawn", function ()
			local is_player = false
			piece_id = 1
			local pawn_x, pawn_y = 1, 2
			local new_x, new_y = 1, 4

			Board.is_player_turn = false
			Board.pieces_len = 0
			Board.board = {
				{}, {}, {}, {}, {}, {}, {}, {}
			}

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
			local is_player = false
			local bishop_x, bishop_y = 4, 4
			local new_x, new_y = 2, 2

			Board.is_player_turn = false
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
			local is_player = false
			local knight_x, knight_y = 5, 5
			local new_x, new_y = 3, 4

			Board.is_player_turn = false
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
			local is_player = false
			local rook_x, rook_y = 1, 1
			local new_x, new_y = 1, 4

			Board.is_player_turn = false
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
			local is_player = false
			local queen_x, queen_y = 1, 1
			local new_x, new_y = 2, 2

			Board.is_player_turn = false
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
			local is_player = false
			local king_x, king_y = 1, 1
			local new_x, new_y = 2, 1

			Board.is_player_turn = false
			assert(Board:can_move_piece_to(is_player, piece_id, king_x, king_y, new_x, new_y))

			new_x, new_y = 8, 1
			Board.is_player_turn = true
			assert.falsy(Board:can_move_piece_to(is_player, piece_id, king_x, king_y, new_x, new_y))
		end)
	end)

end)
