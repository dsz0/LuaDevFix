--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: StartUpFightCmd.lua
-- Author: Lorry  created: 2018/3/12  15:25
--[[Description:战斗相关Mediator和Proxy的注册，当然还包括结算界面等。不过战斗的逻辑基本都在c#中。
这里的Command应该比较少基本不用管。
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")
---@type proxy_enum
local proxy_enum = require("common.proxy_enum")

---@param notification CDemoVO @这个是调用执行发送过来的附加信息，当然也有可能没有参数
_M. StartUpFightCmd = function(notification)
    print("StartUpFightCmd execute:", notification)
end

return _M. StartUpFightCmd