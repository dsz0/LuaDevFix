--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: CloseInstanceUICmd.lua.lua
-- Author: Lorry  created: 2018/3/17  16:36
--[[Description: command,可随意使用Proxy和发送Message DoCmd
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")
---@type proxy_enum
local proxy_enum = require("common.proxy_enum")

require "Common/global_enum"

---@param uiName string @要关闭的
_M. CloseInstanceUICmd.lua = function(uiName)
    if _G.PLOOP_DEBUG_MODE then
        gFacade.SendMessage(Notif["CLOSE_"..string.upper(uiName)]);
        gFacade.RemoveUI(UICustomID[uiName]);
    else
        gFacade.SendMessage(Notif["CLOSE_"..string.upper(uiName)]);
    end
end

return _M. CloseInstanceUICmd.lua