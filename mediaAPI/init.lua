--Variables
local json = require("rapidjson")

M = {}

function M:New(o, CoreIPAddress, login, token)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.CoreIPAddress = CoreIPAddress
	self.login = login
	self.token = token
	return o
end

-------------------------------------------------------------------------
--Authentication
--https://q-syshelp.qsc.com/Content/Management_APIs/authentication.htm
-------------------------------------------------------------------------

-------------------------
--Request a Bearer self.token
-------------------------

function M:RequestToken()
	local function RequestTokenResponse(tbl, code, data)
		if code == 201 then
			local temp = json.decode(data)
			self.token = temp.token
			print("Authorization: " .. self.token)
		else
			print("Error with Authentication", data)
		end
	end

	HttpClient.Upload({
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/logon",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
		},
		Data = json.encode(self.login),
		EventHandler = RequestTokenResponse,
	})
end

-------------------------
--List Root Folders and Files
-------------------------
function M:ListRoot()
	local function ListRootResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			for _, file in ipairs(temp) do
				print("name: " .. file.name .. "     -     path: /" .. file.path)
			end
		else
			error("List Root Folders and Files Error")
		end
	end
	if not self.token then
		self:RequestToken(); Timer.CallAfter(function() self:ListRoot() end, 3)
	end
	HttpClient.Download({
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Timeout = 30,
		EventHandler = ListRootResponse,
	})
end

-------------------------
--List Directory
-------------------------
function M:ListDirectory(DirectoryName)
	local function ListDirectoryResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			for _, ctl in ipairs(temp) do
				print("name: " .. ctl.name .. "     -     path: /" .. ctl.path)
			end
		else
			error("List Directory Error")
		end
	end
	--@param DirectoryName string
	HttpClient.Download({
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media/" .. DirectoryName,
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Timeout = 30,
		EventHandler = ListDirectoryResponse,
	})
end

-------------------------
--Create a Folder
-------------------------
function M:CreateFolder(DirectoryName, NewFolder)
	--@param DirectoryName string
	--@param NewFolder table {name = "name_of_new_folder"}
	local function CreateFolderResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			print("Name : " .. temp.name .. "     -     Path: " .. temp.path)
		elseif code == 400 then
			error("Folder already exists")
		else
			error("Folder Create Error")
		end
	end
	HttpClient.Upload({
		Method = "POST",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media/" .. DirectoryName,
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(NewFolder),
		Timeout = 30,
		EventHandler = CreateFolderResponse,
	})
end

-------------------------
--Create Multiple Folders
-------------------------


function M:CreateMultipleFolders(DirectoryName, NewFolders)
	--@params DirectoryName String
	--@params NewFolders table
	local function CreateMultipleFoldersResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			for idx, ctl in ipairs(temp) do
				print("Name : " .. ctl.name .. "     -     Path: " .. ctl.path)
			end
		else
			error("Folder Create Error")
		end
	end
	HttpClient.Upload({
		Method = "POST",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media/" .. DirectoryName,
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(NewFolders),
		Timeout = 30,
		EventHandler = CreateMultipleFoldersResponse,
	})
end

-------------------------
--Move a Resource
-------------------------
function M:MoveResource(AudioFile, NewPath)
	---@param AudioFile string
	---@param NewPath table
	local function MoveResourceResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			print("New Path: " .. temp.path)
		else
			print("New Path Error")
		end
	end

	HttpClient.Upload({
		Method = "PUT",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media/" .. AudioFile,
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(NewPath),
		Timeout = 30,
		EventHandler = MoveResourceResponse,
	})
end

-------------------------
--Move Multiple Resources
-------------------------
function M:MoveMultipleResources(MultipleNewPath)
	local function MoveMultipleResourcesResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			for _, ctl in ipairs(temp) do
				print("New Path: " .. ctl.path)
			end
		else
			print("New Path Error")
		end
	end
	HttpClient.Upload({
		Method = "PUT",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media/",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(MultipleNewPath),
		Timeout = 30,
		EventHandler = MoveMultipleResourcesResponse,
	})
end

function M:DeleteResources(paths)
	---@param paths: table[string]

	HttpClient.Delete {
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media/",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(paths),
		EventHandler = function(tbl, code, data, err, headers)
			if code ~= 200 then
				print("\rHTML Data: " .. data)
				error("Error deleting resources")
			end
		end
	}
end

-------------------------
--List Playlists
-------------------------


function M:ListPlaylists()
	local function ListPlaylistsResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			for _, ctl in ipairs(temp) do
				print("Playlist: " .. ctl.name .. "     -     ID: " .. ctl.id)
			end
		else
			error("Playlist Download Error")
		end
	end
	HttpClient.Download({
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media_playlists",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Timeout = 30,
		EventHandler = ListPlaylistsResponse,
	})
end

-------------------------
--Show Playlist
-------------------------
function M:ShowPlaylist(PlaylistID)
	--@param PlaylistID string
	local function ShowPlaylistResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			print("Playlist: " .. temp["name"])
			for idx, ctl in ipairs(temp.media) do
				print("     " .. idx .. "     -     Track: " .. ctl.name .. "     -     Path: " .. ctl.path)
			end
		else
			error("Playlist Download Error")
		end
	end
	HttpClient.Download({
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media_playlists/" .. PlaylistID,
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Timeout = 30,
		EventHandler = ShowPlaylistResponse,
	})
end

-------------------------
--Create Playlist
-------------------------
function M:CreatePlaylist(NewPlaylist)
	--@param NewPlaylist table
	local function CreatePlaylistResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			print("Playlist : " .. temp.name .. "     -     ID: " .. temp.id)
		else
			error("Playlist Create Error")
		end
	end
	HttpClient.Upload({
		Method = "POST",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media_playlists",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(NewPlaylist),
		Timeout = 30,
		EventHandler = CreatePlaylistResponse,
	})
end

-------------------------
--Update Playlist
-------------------------

function M:UpdatePlaylist(PlaylistID, UpdatedPlaylist)
	--@params PlaylistID String
	--@params UpdatedPlaylist Table

	local function UpdatePlaylistResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			print("Playlist: " .. temp["name"])
			for idx, ctl in ipairs(temp.media) do
				print("     " .. idx .. "     -     Track: " .. ctl.name .. "     -     Path: " .. ctl.path)
			end
		else
			error("Playlist Update Error")
		end
	end

	--[[
    PlaylistID = "8cc7de74-03a5-4934-b7d5-999ed8b10f94"
    UpdatedPlaylist = {
        name = "MyNewPlaylist2", --Name only needed if changing Playlist name
        media = { --Media only needed if changing Playlist content
            { path = "Audio/ExampleFile1.wav" },
            { path = "Audio/ExampleFile2.wav" },
        },
    }
]]
	HttpClient.Upload({
		Method = "PUT",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media_playlists/" .. PlaylistID,
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(UpdatedPlaylist),
		Timeout = 30,
		EventHandler = UpdatePlaylistResponse,
	})
end

-------------------------
--Add Media
-------------------------

function M:AddMedia(PlaylistID, MediaToAdd)
	--@param PlaylistID string
	--@param MediaToAdd table

	local function AddMediaResponse(tbl, code, data)
		if code == 200 then
			local temp = json.decode(data)
			print("Playlist: " .. temp["name"])
			for idx, ctl in ipairs(temp.media) do
				print("     " .. idx .. "     -     Track: " .. ctl.name .. "     -     Path: " .. ctl.path)
			end
		else
			error("Playlist Add Error")
		end
	end
	HttpClient.Upload({
		Method = "POST",
		Url = "https://" .. self.CoreIPAddress .. "/api/v0/cores/self/media_playlists/" .. PlaylistID .. "/media",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. self.token,
		},
		Data = json.encode(MediaToAdd),
		Timeout = 30,
		EventHandler = UpdatePlaylistResponse,
	})
end

function M:UploadFile(file)
	---@param tbl[string]
	-- Example {name = TestName, path = /example/path, link = www.example.com/testfile}
	HttpClient.Download {
		Url = file.link,
		EventHandler = function(tbl, code, data, err, headers)
			if code == 200 then
				local song = io.open("design" .. file.path, "wb")
				if song ~= nil then
					song:write(data)
					song:close()
				end
			else
				print(code, data)
				error(string.format("Error Downloading %s", file.name))
			end
		end
	}
end

-------------------------
--Initialize the request token and auto-refresh
-------------------------

function M:Init()
	self.timer = Timer.New()
	self.timer.EventHandler = function() self:RequestToken() end
	self:RequestToken()
	self.timer:Start(3500)  -- refresh token every 58 minutes; Expires after 60 minutes
end

return M
