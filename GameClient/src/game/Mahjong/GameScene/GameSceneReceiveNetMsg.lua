local GameScene = class("GameScene")
local UserInfo              = require("game.clientdata.UserInfo")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")
local HeartBeat             = require("game.Lobby.Base.HeartBeat")
local NetWork               = require("game.net.NetWork")
local Respones              = require("game.net.Respones")

function GameScene:initNetEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self._gameScene, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self._gameScene, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self._gameScene, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self._gameScene, self.onEventClosed)

    addEvent(ClientEvents.ON_NETWORK_OFF, self, self._gameScene, self.onEventNetWorkOff)
    addEvent("HeartBeatRes", self, self._gameScene, self.onEventHeartBeat)
end

function GameScene:onEventNetConnect(event)
    Game.showPopLayer('TipsLayer',{"网络连接成功!"})
    Game.popLayer('LoadingLayer')
    --重新登录
    local loginType = UserInfo.getLoginType()
    if loginType == 'uname' then
        local name  = UserInfo.getUserAccount() 
        local pwd   = UserInfo.getUserPwd()
        AuthServiceProxy:getInstance():sendUnameLogin(name,pwd)
    elseif loginType == 'guest' then
        local guestkey = UserInfo.getUserGuestKey()
        AuthServiceProxy:getInstance():sendGuestLogin(guestkey)
    end
end

function GameScene:onEventNetConnectFail(event)
    Game.showPopLayer('TipsLayer',{"网络连接失败!"})
    Game.showPopLayer('LoadingLayer')
end

function GameScene:onEventClose(event)
    Game.showPopLayer('LoadingLayer')
end

function GameScene:onEventClosed(event)
    Game.showPopLayer('LoadingLayer')
end

function GameScene:onEventHeartBeat(event)
    local body = event._usedata
    if body.status == Respones.OK then
        -- print('GameScene>> onEventHeartBeat')
        HeartBeat:getInstance():onHeartBeat()
    end
end

function GameScene:onEventNetWorkOff(event)
    NetWork:getInstance():reConnect()
end

return GameScene