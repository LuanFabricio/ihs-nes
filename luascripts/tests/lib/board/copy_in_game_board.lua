local bit = require("bit")
require 'busted.runner'
require 'lib/board'
require 'lib/constants'
require 'tests/memory'

describe("copy_in_game_board", function ()
	it("Should copy memory pieces to internal board matrix", function ()
		MEMORY_ARR = {
			-- rook (4, 8)
			[0x0200] = CONSTANTS.Y_PADDING + bit.lshift(7, 3),
			[0x0201] = 0x05,
			[0x0202] = 0x01,
			[0x0203] = CONSTANTS.X_PADDING + bit.lshift(3, 3),
			-- pawn (2, 1)
			[0x0204] = CONSTANTS.Y_PADDING + bit.lshift(0, 3),
			[0x0205] = 0x01,
			[0x0206] = 0x03,
			[0x0207] = CONSTANTS.X_PADDING + bit.lshift(1, 3),
		}

		memory.MEMORY_ARR = MEMORY_ARR

		Board:copy_in_game_board(memory)

		local expected_not_nil = { { 4, 8, memory.readbyte(0x0201)}, { 2, 1, memory.readbyte(0x0205) }}

		for i = 1, 8, 1 do
			for j = 1, 8, 1 do
				local should_not_be_nil = false
				for k = 1, #expected_not_nil, 1 do
					should_not_be_nil = should_not_be_nil or (j == expected_not_nil[k][1] and i == expected_not_nil[k][2])
				end
				if not should_not_be_nil then
					assert(Board.board[i][j] == nil)
				end
			end
		end


		for i = 1, #expected_not_nil do
			local x, y = expected_not_nil[i][1], expected_not_nil[i][2]
			local piece_type = expected_not_nil[i][3]
			assert(Board.board[y][x][1] == piece_type, Board.board[y][x][1]  .. " != " .. piece_type)
		end
	end)
end)
