local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

describe("move_in_board_piece_to", function ()
	it("Should move a piece by board position", function ()
		MEMORY_ARR = {
			-- Rook (5, 4)
			[0x0200] = CONSTANTS.Y_PADDING + 3 * 8,
			[0x0201] = 0x04,
			[0x0202] = 0x03,
			[0x0203] = CONSTANTS.X_PADDING + 4 * 8,
		}
		memory.MEMORY_ARR = MEMORY_ARR

		local from_x = bit.rshift(memory.readbyte(0x0203) - CONSTANTS.X_PADDING, 3) + 1
		local from_y = bit.rshift(memory.readbyte(0x0200) - CONSTANTS.Y_PADDING, 3) + 1
		local expected_x, expected_y = 5, 6
		local target_string = "" .. expected_x .. "" .. expected_y
		local from_string = "" .. from_x .. "" .. from_y
		-- (5, 4) -> (5, 6)
		Board:move_in_board_piece_to(memory, from_string, target_string)

		local board_x = bit.rshift(memory.readbyte(0x0203) - CONSTANTS.X_PADDING, 3) + 1
		local board_y = bit.rshift(memory.readbyte(0x0200) - CONSTANTS.Y_PADDING, 3) + 1

		assert(board_x == expected_x, board_x .. "!=" ..expected_x)
		assert(board_y == expected_y, board_y .. "!=" ..expected_y)
	end)

	it("Should kill a enemy piece", function ()

	end)
end)
