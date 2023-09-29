local bit = require("bit")
require 'busted.runner'
require 'lib/input'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'
require 'tests/zapper'

describe("handle_player_click", function ()
	it("Should update current_piece when piece_type != 0", function ()
		MEMORY_ARR = {
			-- Knight (5, 2)
			[0x0200] = CONSTANTS.Y_PADDING + bit.lshift(1, 3),
			[0x0201] = 0x03,
			[0x0202] = 0x03,
			[0x0203] = CONSTANTS.X_PADDING + bit.lshift(4, 3),
		}
		memory.MEMORY_ARR = MEMORY_ARR

		zapper.x = CONSTANTS.X_PADDING + bit.lshift(4, 3)
		zapper.y = CONSTANTS.Y_PADDING + bit.lshift(1, 3)
		zapper.fire = true

		local current_piece = {
			index = 0,
			type = 0,
			x = 0,
			y = 0,
		}

		current_piece = Input:handle_player_click(zapper.read(), memory, Board, current_piece)

		local expected_x = 5
		local expected_y = 2
		local expected_type = 3
		local expected_index = 1
		assert(current_piece.x == expected_x, current_piece.x .. " != " .. expected_x)
		assert(current_piece.y == expected_y, current_piece.y .. " != " .. expected_y)
		assert(current_piece.type == expected_type, current_piece.type .. " != " .. expected_type)
		assert(current_piece.index == expected_index, current_piece.index .. " != " .. expected_index)
	end)
end)
