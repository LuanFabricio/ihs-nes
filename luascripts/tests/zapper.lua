zapper = { x = 0, y = 0, fire = false }
zapper.read = function ()
	return {
		x = zapper.x,
		y = zapper.y,
		fire = zapper.fire
	}
end

return zapper
