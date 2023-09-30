local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

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

		Board.pieces_len = 2
		memory.MEMORY_ARR = MEMORY_ARR
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

		memory.MEMORY_ARR = MEMORY_ARR
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

		Board.pieces_len = 3
		memory.MEMORY_ARR = MEMORY_ARR
		Board:kill_piece(memory, 2, 3)
		for i=0, 3, 1 do
			assert(memory.readbyte(0x0208 + i) == 0)
		end

	end)
end)
