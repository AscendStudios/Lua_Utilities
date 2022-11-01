local xml = require "luaXML"
local rj = require "rapidjson"

local file = {}

function file.read(file_path)
    local file = io.open(file_path, 'r')
    data = file:read("*a")
    file:close()
    return data
end

function file.write(file_path, data)
    local file = io.open(file_path, 'w+')
    file:write(data)
    file:close()
end

file.xml = {
    read = function(file_path)
        return xml.eval(file.read(file_path))
    end,
    }

file.json = {
    read = function(file_path)
        return rj.decode(file.read(file_path))
    end,

    write = function(file_path, data)
        if type(data) == type({}) then
            file.write(file_path, rj.encode(data))
        else
            print("data should be a table")
        end
    end
    }

-- Add the dir library to the file library
file.dir = dir

-- Function will get or create and get a directory
file.dir.getCreate = function(path)
    if not file.dir.get(path) then
        file.dir.create(path)
    end
    return file.dir.get(path)
end
