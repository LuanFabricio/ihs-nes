MEMORY = {
	board = {
		pieces_start = 0x0200,
		pieces_len = 7,
		-- remove
		player = {
			y = 0x0200,
			type = 0x0201,
			attr = 0x0202,
			x = 0x0203,
		},
	}
}

return MEMORY
