local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

describe('move_piece_to: Should move a piece', function ()
	local piece_index
	it("Should move piece 0 to (0x42, 0x42)", function ()
		piece_index = 0
		local x, y = 0x42, 0x42

		memory.MEMORY_ARR = { }
		Board:move_piece_to(memory, piece_index, x, y)

		local address = MEMORY.board.pieces_start + piece_index * 4
		local mem_y = memory.readbyte(address)
		local mem_x = memory.readbyte(address + 3)

		assert(mem_x == x, mem_x .. "!=" ..  x)
		assert(mem_y == y, mem_y .. "!=" ..  y)
	end)

	it("Should move piece 1 to (0x50, 0x42)", function ()
		piece_index = 1
		local x, y = 0x50, 0x42

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
