local version       = '2.1.1'

local customCodeTag = '--CUSTOM_CODE'
local editorExe     = 'World Editor.exe'
local gameExe       = 'Warcraft III.exe'
local color         = { black = '\27[30m', red = '\27[31m', green = '\27[32m', yellow = '\27[33m', blue = '\27[34m', magenta = '\27[35m', cyan = '\27[36m', white = '\27[37m', reset = '\27[0m' }

local COMMAND_START_GAME = 'game'
local COMMAND_START_EDITOR = 'editor'

-- Translation table
-- can be called with a text key like
-- local text = tr"ERROR_MSG"
local tr = {}
setmetatable(tr, {
	_lang = nil,
	__call = function(tbl, key)
		local locale = tbl._lang
		-- Lookup translation if exists
		local requested = tbl[locale] and tbl[locale][key]
		if not requested then
			-- default to EN/RU
			requested = tbl.en[key] or tbl.ru[key]
		end
		return requested
	end
})
do
	local t = tr
	tr.ru, tr.en = {}, {}
	-- Adds translations to table
	local function add(textKey, en, ru)
		assert(t.en[textKey] == nil, 
			'English translation already exists with key: '.. tostring(textKey))
		assert(t.ru[textKey] == nil, 
			'Russian translation already exists with key: '.. tostring(textKey))
		
		t.en[textKey] = en
		t.ru[textKey] = ru
	end
	--add(key, en, ru)
	add('ERROR_EDITOR_OPEN', 'Error! Editor is open', 'Ошибка! Редактор открыт')
	add('ERROR_GAME_OPEN', 'Error! Game is running', 'Ошибка! Игра запущена')
	add('DETERMINE_PROJECT_FOLDER', 'Determining project folder', 'Определяем папку проекта')
	add('ERROR_PROJECT_FOLDER_NOT_FOUND', 'Error! Project folder not found', 'Ошибка! Папка с проектом не найдена')
	add('ERROR_MAP_FOLDER_NOT_FOUND', 'Error! Map folder not found', 'Ошибка! Папка с картой не найдена')
	add('ERROR_FILE_NOT_FOUND', 'Error! File not found', 'Ошибка! Файл не найден')
	add('BUILD_STARTING', 'Starting the build', 'Начинаем сборку')
	add('IGNORED', 'ignored', 'игнорирован')
	add('WAS_NOT_CHANGED', 'was not changed.', 'не был изменён.')
	add('OPEN_AND_SAVE_IN_EDITOR', 'Open and save the map in editor', 'Откройте и сохраните карту в редакторе!')
	add('BUILD_COMPLETED_SUCCESSFULLY', 'Build completed successfully', 'Сборка успешно завершена')
	add('STARTING_EDITOR', 'Starting editor', 'Запускаем редактор')
	add('STARTING_GAME', 'Starting game', 'Запускаем игру')
	add('REGISTRY_DOESNT_CONTAIN_GAMEPATH', 'Registry key doesn\'t contain path to game', 'Ключ реестра не содержит пути к игре')
	add('LUAC_SYNTAX_ERROR', 'Luac detected a syntax error:', 'Luac нашла синтаксическую ошибку:')
	add('LUAC_NOT_FOUND', 'Luac not found.', 'Luac не найдена.')
	add('SKIPPING_SYNTAX_CHECK', 'Skipping Lua syntax check.', 'Продолжаем без проверки синтаксиса.')
	--add(key, en, ru)
end

local function log(str)
	--print('[' .. color.white .. os.date('%c') .. color.reset .. '] ' .. str)
	return false
end

local function help(str)
	return 'https://github.com/nazarpunk/cheapack#' .. str
end

local function declension (num, d1, d4, d5)
	num = math.abs(num) % 100
	if num >= 11 and num <= 19 then return d5 end
	num = num % 10
	if num == 1 then return d1 end
	if num > 1 and num <= 4 then return d4 end
	return d5
end

local function isFileExists(file)
	local ok, _, code = os.rename(file, file)
	if not ok and code == 13 then return true end
	return ok
end

-- returns file list of files in directory
-- if an error occurs, returns false plus an error message
-- if outTable was provided, updates that table with entries and returns it
local function folderFileList(pathFolder, outTable)
	local outTable = outTable or {}
	-- /s = display files of folder and all subfolders
	-- /b = bare
	-- /o:gn = sort: directories first, sort by name
	-- in case of error, last line is ~= "ok" and first line is an error msg
	-- Note: for some reason, dir doesn't set %errorlevel%
	local dirCmd = [[dir "]] .. pathFolder .. [[" /s /b /o:gn 2>&1 && echo ok|| echo bad]]
	local dirErrorIndex = #outTable + 1 -- first line
	for item in io.popen(dirCmd):lines() do
		table.insert(outTable, item)
	end
	
	local exitCode = table.remove(outTable)
	if exitCode == "ok" then
		return outTable
	else
		return false, assert(outTable[dirErrorIndex])
	end
end

local function fileGetContent(path, mode)
	local file, err    = io.open(path, mode)
	local content = file:read '*a'
	file:close()
	return content
end

local function tableInsertReadStr(t, file)
	local start = file.counter
	local stringbyte = string.byte
	local content = file.content

	for index = start, #content do
		file.counter = file.counter + 1

		if stringbyte(content, index) == 0 then
			local out = content:sub(start, index - 1)
			table.insert(t, out)
			return out
		end
	end

	return nil
end

local function tableInsertReadInt(t, f)
	local bytes = f:read(4)
	if bytes == nil or bytes:len() < 4 then return nil end
	local v = ('<I4'):unpack(bytes)
	table.insert(t, v)
	return v
end

local function parseWct(path)
	local out  = {}
	local content = fileGetContent(path, 'rb')
	local file = {
		content = content,
		counter = 1,
		read = function(self, num)
			if self.counter >= #self.content then return nil end

			local result = self.content:sub(self.counter, self.counter + num - 1)

			self.counter = self.counter + num
			return result
		end,
		close = function() end
	}

	tableInsertReadInt(out, file)
	tableInsertReadInt(out, file)
	tableInsertReadStr(out, file)
	tableInsertReadInt(out, file)
	tableInsertReadStr(out, file)
	while true do
		local item = tableInsertReadInt(out, file)
		if item == nil then break end
		if item > 0 then
			item = tableInsertReadStr(out, file)
			if item == nil then break end
		end
	end
	file:close()
	return out
end

local function isProcessRun(processname)
	local filedata = io.popen('tasklist /NH /FO CSV /FI "IMAGENAME eq ' .. processname .. '"')
	local output   = filedata:read()
	filedata:close()
	return output:find(processname) ~= nil
end

local function getProjectDir()
	return debug.getinfo(3, 'S').source:sub(2):match('(.*/)'):gsub('%/$', ''):gsub('/', '\\')
end

print(help('cheapack') .. ' ' .. color.blue .. version .. color.reset)

return function(param)
	-- param
	param = param or {}
	if type(param) ~= 'table' then param = { param } end
	param.map      = param.map or 'map.w3x'
	param.src      = param.src or 'src'
	param.reforged = not not param.reforged
	
	-- set options
	do
		-- defaults: preserve old behavior for now
		local optionsDefault = {
			language = "ru",
			consoleColor = true
		}
		if param.options then
			-- add missing options to user-supplied table
			for k, default in pairs(optionsDefault) do
				if param.options[k] == nil then
					param.options[k] = default
				end
			end
		else
			param.options = optionsDefault
		end
		
		-- apply language
		tr._lang = param.options.language
		
		-- apply colors
		if param.options.consoleColor == false then
			for name, _ in pairs(color) do
				-- make all no-op
				color[name] = ""
			end
		end
	end
	
	-- check process
	if param.run == COMMAND_START_EDITOR and isProcessRun(editorExe) then
		return log(color.red .. tr'ERROR_EDITOR_OPEN' .. '\n' .. color.yellow .. editorExe .. color.reset)
	end
	if param.run == COMMAND_START_GAME and isProcessRun(gameExe) then
		return log(color.red .. tr'ERROR_GAME_OPEN' .. '\n' .. color.yellow .. gameExe .. color.reset)
	end

	-- param: project
	if param.project == nil then
		param.project = getProjectDir()
		log(color.cyan .. tr'DETERMINE_PROJECT_FOLDER' .. color.yellow .. '\n' .. param.project .. color.reset .. '\n' .. help('project'))
	end
	if not isFileExists(param.project) then
		return log(color.red .. tr'ERROR_PROJECT_FOLDER_NOT_FOUND'.. '\n' .. color.yellow .. param.project .. color.reset .. '\n' .. help('project'))
	end

	-- param: map
	local mapFolderPath = param.project .. '\\' .. param.map
	if not isFileExists(mapFolderPath) then
		return log(color.red .. tr'ERROR_MAP_FOLDER_NOT_FOUND' .. '\n' .. color.yellow .. mapFolderPath .. color.reset .. '\n' .. help('map'))
	end

	local noFileError    = color.red .. tr'ERROR_FILE_NOT_FOUND' .. '\n' .. color.yellow
	-- war3map.wct
	local war3mapWctPath = param.project .. '\\' .. param.map .. '\\war3map.wct'
	if not isFileExists(war3mapWctPath) then return log(noFileError .. war3mapWctPath .. color.reset) end

	-- war3map.lua
	local war3mapLuaPath = param.project .. '\\' .. param.map .. '\\war3map.lua'
	if not isFileExists(war3mapWctPath) then return log(noFileError .. war3mapLuaPath .. color.reset) end

	-- param: src
	log(color.cyan .. tr'BUILD_STARTING' .. color.reset)
	local pathlist = {}
	if type(param.src) == 'string' then param.src = { param.src } end
	for i = 1, #param.src do
		local suffix = param.src[i]:sub(-4):lower() == '.lua' and '' or '\\*.lua'
		local path   = ((param.project .. '\\' .. param.src[i]):gsub("[\\/]+$", ""))
		if not isFileExists(path) then return log(noFileError .. path .. color.reset) end
		
		local dirPath = path .. suffix
		-- add files from directory to pathlist
		local ok, err = folderFileList(dirPath, pathlist)
		
		if not ok then
			log(string.format(
				"%sdir exited with error: '%s' for '%s'%s",
				color.red, err, dirPath, color.reset
			))
			os.exit(2)
		end
	end
	
	local code                 = customCodeTag
	local pathlistDublicate    = {}
	local pathlistDublicateLen = 0
	for i = 1, #pathlist do
		local path = pathlist[i]
		if pathlistDublicate[path] == nil then
			pathlistDublicate[path] = true
			code                    = code .. '\r\n' .. fileGetContent(path, 'rb')
			print(color.yellow .. path .. color.reset)
		else
			pathlistDublicateLen = pathlistDublicateLen + 1
			print(color.red .. path .. color.white .. ' [' .. tr'IGNORED' ..']' .. color.reset)
		end
	end
	code = code .. '\r\n' .. customCodeTag
	if pathlistDublicateLen > 0 then
		log('Обнаружено ' .. color.red .. pathlistDublicateLen .. color.reset .. ' ' .. declension(pathlistDublicateLen, 'повторное включение', 'повторных включений', 'повторных включений'))
	end

	-- patch war3map.wct
	local wct     = parseWct(war3mapWctPath)
	log("Parsed wct")

	local wctFile = assert(io.open(war3mapWctPath, 'wb'))
	do
		-- Escape single '%' for WE, because it incorrectly handles them
		-- Putting a single % in code will either cause an error or crash on save
		local codeEscapedWE = (code:gsub("%%", "%%%%"))
		wct[4]        = codeEscapedWE:len() + 1
		wct[5]        = codeEscapedWE
		for i = 1, #wct do
			local data = wct[i]
			if type(data) == 'number' then
				wctFile:write(('<I4'):pack(data))
			elseif type(data) == 'string' then
				wctFile:write(data .. '\0')
			end
		end
		wctFile:close()
	end

	log("Patched wct")

	-- replace war3map.lua
	local luaContent           = fileGetContent(war3mapLuaPath, 'rb')
	local luaFile              = io.open(war3mapLuaPath, 'wb')

	local luaContentNew
	local tagOpenStart, tagOpenEnd = luaContent:find(customCodeTag, 1, true)

	-- Find first, last customCodeTag and insert code inbetween
	if tagOpenStart then
		local tagCloseStart, tagCloseEnd = luaContent:find(customCodeTag, tagOpenEnd, true)
		if tagCloseStart then
			luaContentNew = (luaContent:sub(1, tagOpenStart-1)
				.. code
				.. luaContent:sub(tagCloseEnd+1))

			luaFile:write(luaContentNew)
		else
			luaFile:write(luaContent)
			log(color.yellow .. 'war3map.lua' .. color.reset .. ' '.. tr'WAS_NOT_CHANGED' ..' \n' .. color.red .. tr'OPEN_AND_SAVE_IN_EDITOR' .. color.reset)
		end
	end

	luaFile:close()
	log(color.cyan .. tr'BUILD_COMPLETED_SUCCESSFULLY' .. color.reset)

	-- param: export
	if param.export ~= nil then
		local json         = require 'json'
		local exportFolder = param.project .. '\\' .. param.export
		if not isFileExists(exportFolder) then
			os.execute('mkdir ' .. exportFolder)
		end
		wctFile = io.open(exportFolder .. '\\war3map.wct.json', 'wb')
		wctFile:write(json.encode(parseWct(war3mapWctPath))):close()
	end
	
	-- param: syntaxCheck
	if param.syntaxCheck then
		-- Lua 5.1-compat: os.execute changed in 5.2
		local exitStatus = os.execute("luac -v > nul")
		local luacExists = exitStatus == 0 or exitStatus == true
		
		if luacExists then
			local p = io.popen('luac -p "'.. war3mapLuaPath ..'" 2>&1')
			local errorMsg = p:read("*a")
			p:close()
			
			if #errorMsg > 0 then
				log(color.red .. tr'LUAC_SYNTAX_ERROR')
				log(errorMsg .. color.reset)
				return false
			end
		else
			log(color.red .. tr'LUAC_NOT_FOUND' .." ".. tr'SKIPPING_SYNTAX_CHECK' .. color.reset)
		end
	end
	
	-- param: run
	param.run = param.run or os.getenv('run') or nil
	if param.run == COMMAND_START_EDITOR or param.run == COMMAND_START_GAME then

		-- param: game
		if param.game == nil then
			local registry = require 'registry'
			local key      = [[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Warcraft III]]
			local keys     = registry.getkey(key)
			if keys == nil then
				log(color.red .. tr'REGISTRY_DOESNT_CONTAIN_GAMEPATH' .. '\n' .. color.white .. key .. color.reset)
				return false
			end
			for _, v in pairs(keys.values) do
				if v.name == 'InstallPath' or v.name == 'InstallSource' or v.name == 'InstallLocation' then
					param.game = v.value
				end
			end
			param.game = param.game .. '\\_retail_\\x86_64'
		end

		local file
		if param.run == COMMAND_START_EDITOR then
			file = param.game .. '\\' .. editorExe
			log(color.cyan .. tr'STARTING_EDITOR' .. color.reset)
		elseif param.run == COMMAND_START_GAME then
			file = param.game .. '\\' .. gameExe
			log(color.cyan .. tr'STARTING_GAME' .. color.reset)
		end
		local execute = 'start  "" "' .. file .. '" -launch -loadfile "' .. param.project .. '\\' .. param.map .. '"'
		if isFileExists(file) then
			print(color.yellow .. file .. color.reset)
			os.execute(execute)
		else
			log(noFileError .. file .. color.reset)
		end
	elseif param.run:lower() == "launch_nothing" or param.run == nil then
		-- Don't do anything
	else
		error("Unknown run parameter='".. tostring(param.run) .."'")
	end
end
