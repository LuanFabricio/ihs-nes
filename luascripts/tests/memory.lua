-- proxy to memory.writebyte
MEMORY_ARR = { }
memory = { MEMORY_ARR = { } }
memory.writebyte = function (address, new_value)
	memory.MEMORY_ARR[address] = new_value
end

memory.readbyte = function (address)
	if memory.MEMORY_ARR[address] then
		return memory.MEMORY_ARR[address]
	end

	return 0
end

return MEMORY_ARR, memory
