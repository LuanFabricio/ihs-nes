local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

describe("count_pieces", function ()
	it("Should count the quantity of pieces in the board", function ()
		MEMORY_ARR = {}
		local expected_length = 2

		local n = expected_length * 4 - 1
		for i = 0, n, 1 do
			MEMORY_ARR[MEMORY.board.pieces_start + i] = 0xff
		end

		memory.MEMORY_ARR = MEMORY_ARR


		local length = Board:count_pieces(memory)

		assert(length == expected_length, length .. " != " .. expected_length)
	end)
end)
