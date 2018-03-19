--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: OpenInstanceUICmd.lua
-- Author: Lorry  created: 2018/3/17  16:21
--[[Description: command,可随意使用Proxy和发送Message DoCmd
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")
---@type proxy_enum
local proxy_enum = require("common.proxy_enum")

---@param uiName string @打开某个界面
_M.OpenInstanceUICmd = function(uiName)
    if _G.PLOOP_DEBUG_MODE then
        --注册某个
        --gFacade.RegisterUI(UICustomID.Test, CInstanceMediator)
    else

    end
end

return _M. OpenInstanceUICmd