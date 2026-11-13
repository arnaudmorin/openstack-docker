-- LUA wrapper for nginx openstack token
-- @authors Arnaud Morin <arnaud.morin@gmail.com>
local handle = io.popen("/bin/cloudflow-get-token")
local result = handle:read("*a")
handle:close()
return result:gsub("[\n\r]+", "")
