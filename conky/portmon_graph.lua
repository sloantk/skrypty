do
	local count = 0

	function conky_update_count(arg)
		count = tonumber(string.match(arg, '(%d+)'))
		return ''
	end

	function conky_get_count()
		return count
	end
end
