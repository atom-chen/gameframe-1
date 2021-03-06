Logger.init("logger/system_server/", "system", true)

require("database/mysql_game")
require("functions")

-- 初始化协议模块
local proto_type = {
    PROTO_JSON = 0,
    PROTO_BUF = 1,
}

ProtoMan.init(proto_type.PROTO_BUF)
if ProtoMan.proto_type() == proto_type.PROTO_BUF then 
  local cmd_name_map = require("cmd_name_map")
  if cmd_name_map then 
    ProtoMan.register_protobuf_cmd_map(cmd_name_map)
  end
end

local game_config 	= require("game_config")
local Stype 		= require("Stype")
local servers 		= game_config.servers

-- 开启网关端口监听
Netbus.tcp_listen(servers[Stype.System].port)
print("[System Server]>>>>> Start at ".. servers[Stype.System].port)

local system_service = require("system_server/system_service")
local ret = Service.register(Stype.System, system_service)
if ret then 
  print("register [System service]: success!!!")
else
  print("register [System service]: failed!!!")
end


