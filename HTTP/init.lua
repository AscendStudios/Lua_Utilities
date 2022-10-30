-- Base HTTP Response Function
local HTTP = {
    response = function(tbl, code, data, err, headers)
        if err then Log.Error( "Error from ".. tbl.Url .. " Return Code " .. code .. " Error: " .. err ) end
        if code == 200 then
            return data
        elseif code == 0 then
            Log.Error("Cannot connect to Cue Server")
        else
            print(code) --TODO: log error
        end
    end
}

return HTTP