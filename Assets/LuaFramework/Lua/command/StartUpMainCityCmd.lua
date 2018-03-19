--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: StartUpMainCityCmd.lua
-- Author: Lorry  created: 2018/3/12  15:26
--[[Description: command,可随意使用Proxy和发送Message DoCmd
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")

require "Common/global_enum"
-----Mediator引入
require("framework.demo.InstanceMediator")
require("ui.common.TipsMediator")

---@param notification CDemoVO @这个是调用执行发送过来的附加信息，当然也有可能没有参数
_M.StartUpMainCityCmd = function(notification)
    print("StartUpMainCityCmd 进入了主城", notification)
    --注册主城所需Mediator，这些Mediator由mediator_manager持有。
    gFacade.RegisterUI(UICustomID.Test, CInstanceMediator)
    gFacade.RegisterUI(UICustomID.Tips, CTipsMediator)

    gFacade.SendMessage(Notif.OPEN_TEST)
end

return _M. StartUpMainCityCmd
