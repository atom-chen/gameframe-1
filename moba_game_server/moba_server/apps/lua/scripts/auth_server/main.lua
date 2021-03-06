Logger.init("logger/auth_server/", "auth", true)

-- 连接到auth center mysql 数据库
require("database/mysql_auth_center")
require("functions")

math.newrandomseed()

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

local game_config = require("game_config")
local servers = game_config.servers
local Stype = require("Stype")

-- 开启网关端口监听
Netbus.tcp_listen(servers[Stype.Auth].port)
-- Netbus.ws_listen(servers[Stype.Auth].port)
print("[Auth Server]>>>>> Start at ".. servers[Stype.Auth].port)

local auth_service = require("auth_server/auth_service")
local ret = Service.register(Stype.Auth, auth_service)
if ret then 
  print("register [Auth service] success!!!")
else
  print("register [Auth service] failed!!!")
end


