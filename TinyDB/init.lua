--[[

TinyDB

A json powered database that allows you to quickly access information globally.

Example Usage:

  database = require "TinyDB"

  db = {name = "MyTinyDB"}

  db = database:new(db)

  db:set("hello", "world")

  print(db:get("hello"))

Note: Be careful - I beleive there are edge cases when one instance of the db class may
have the database in memory as another instance writes new data to the actual file; in this
case, the data may be loss from the instance that was writing just before the other made changes

--]]

local rj = require "rapidjson"

-- FILE IO Operations --

local file = {}

function file.read(file_path)
  local f = io.open(file_path, 'r')
  if f == nil then return nil end
  local data = f:read("*a")
  f:close()
  return data
end

function file.write(file_path, data)
  local f, err = io.open(file_path, 'w+')
  if err then
    print(err, file_path); return err
  end
  f:write(data)
  f:close()
end

file.json = {
  read = function(file_path)
    local data = file.read(file_path)
    if data then
      return rj.decode(file.read(file_path))
    end
  end,

  write = function(file_path, data)
    assert(type(data) == "table")
    file.write(file_path, rj.encode(data))
  end
}

-- Add the dir library to the file table
file.dir = dir

function file.root()
  if System.IsEmulating then
    return "design/"
  else
    return "media/"
  end
end

local function create_loadstring(dotted_str)
  local load_string = [[
      if not val then return f['str'] end
      f['str'] = val
      return f
    ]]
  local braces = string.gsub(dotted_str, "%.", "']['")
  return string.gsub(load_string, "str", braces)
end

local function check_name(name)
  assert(name ~= nil and type(name) == "string", "Please provide a name for the database.")
  local extension = string.find(name, "%.")
  if extension then return name else return name .. ".json" end
end


local function update_table_using_dotted_str(f, dotted_str, val)
  local env = { f = f, val = val }
  local load_str = create_loadstring(dotted_str)
  assert(load(load_str, nil, nil, env))()
  if val then return load(load_str, "FunctionLoader", "bt", env)() end
  f = load(load_str, "FunctionLoader", "bt", env)()
  return f
end

Database = {
  -- Database Atrributes- -
  name = nil,
}

function Database:New(obj)
  --Create the self obj--
  obj = obj or Database
  --dictionary of args--

  setmetatable(obj, self)
  self.__index = self
  self.name = check_name(obj.name)
  return self
end

function Database.Get(self, key)
  local f = file.json.read(file.root() .. self.name)
  return update_table_using_dotted_str(f, key)
end

function Database.Set(self, key, value)
  local f = file.json.read(file.root() .. self.name) or {}
  f = update_table_using_dotted_str(f, key, value)
  file.json.write(file.root() .. self.name, f)
end

return Database

-- db = { name = "Tester" }

-- db = Database:new(db)

-- print(db.name)

-- db:set("hello", "world")
