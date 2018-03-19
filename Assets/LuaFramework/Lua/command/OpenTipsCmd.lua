--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: OpenTipsCmd.lua
-- Author: Lorry  created: 2018/3/3  18:11
--[[Description: command类，一个Mediator操作本身持有的view和proxy是不调用command的。
但是如果要操作其他Mediator，就需要通过command了。command可随意使用Proxy和发送Message DoCmd
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")

---@param msg string @这个是调用执行发送过来的附加信息，当然也有可能没有参数
_M.OpenTipsCmd = function(msg)
    gFacade.SendMessage(Notif.OPEN_TiPS, msg)
    local StartMainCity;
    local StartFight;

end
