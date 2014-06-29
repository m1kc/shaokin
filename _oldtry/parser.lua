source = ''

roomName = 'A room without a name'

function skipWhitespace(onlySpaces)
	if onlySpaces then
		while source:sub(0,1) == ' ' do
			source = source:sub(2);
		end
	else
		while source:sub(0,1) == ' ' or source:sub(0,1) == "\n" or source:sub(0,1) == "\r" do
			source = source:sub(2);
		end
	end
end

function getCommand()
	skipWhitespace();
	local result = '';
	while true do
		if source:sub(0,1) == ' ' or source:sub(0,1) == "\n" or source:sub(0,1) == "\r" then
			return result
		else
			result = result .. source:sub(0,1);
			source = source:sub(2);
		end
	end
end

function getLine(onlySpaces)
	skipWhitespace(onlySpaces);
	local result = '';
	while true do
		if source:sub(0,1) == "\n" or source:sub(0,1) == "\r" then
			return result
		else
			result = result .. source:sub(0,1);
			source = source:sub(2);
		end
	end
end

function getParagraph()
	local result = ''
	local z = 0
	while true do
		local line = getLine(false)
		if line == '' or line == ' ' then
			return result
		else
			result = result .. line .. "\n"
			z = z+1
			if z > 10 then print(result); return 'anus'; end
		end
	end
end

function parse(filename)
	local inputStream = io.open(filename);
	source = inputStream:read("*a");
	while true do
		cmd = getCommand();
		if cmd:byte(1) == 208 and cmd:byte(2) == 205 then
			-- "РН"
			print '<room name>'
			roomName = getLine(true);
			print('room name is <<' .. roomName .. '>>');
		elseif cmd:byte(1) == 206 and cmd:byte(2) == 207 then
			-- "ОП"
			print '<description>'
			local args = getLine(true)
			print('args: <<' .. args .. '>>')
			local desc = getParagraph()
			print('desc: <<' .. desc .. '>>')
		else
			print('unknown command: ' .. cmd);
			print 'its codes:'
			local i = 0
			while i < #cmd do
				i = i+1;
				print(cmd:byte(i));
			end
			break;
		end
	end
	--room1.dsc = source;
end

-- main
parse 'data/Room1.txt'
