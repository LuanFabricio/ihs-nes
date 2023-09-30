local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

describe("get_piece_from", function ()
	for i = 0, 4 * 64, 1 do
		MEMORY_ARR[MEMORY.board.pieces_start+i] = 0x00
	end

	it("Should return board_x and board_y when cant find a piece", function ()
		local x, y = 0x60, 0x70

		local expected_x = bit.rshift(x - CONSTANTS.X_PADDING, 3) + 1
		local expected_y = bit.rshift(y - CONSTANTS.Y_PADDING, 3) + 1

		Board.pieces_len = 0
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
