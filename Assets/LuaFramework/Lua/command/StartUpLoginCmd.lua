--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: StartUpLoginCmd.lua
-- Author: Lorry  created: 2018/3/12  15:26
--[[Description: 用于登陆场景的启动，注册活动，选服，选择角色等Mediator及对应的Proxy
因为这里的很多数据都要带到后面的场景中，所以这里必然要注册几乎所有的Proxy和Command
但是因为每个场景的UIRoot都会被销毁，所以我们也要调用MediatorManager的Destroy(Clear)。
这样一来，每个进入一个新场景就要重新注册该场景所需要的Mediator，请注意。
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")
---@type proxy_enum
local proxy_enum = require("common.proxy_enum")

require "Common/global_enum"
---Proxy引入
require("ui.login.LoginProxy")
---Command引入
require("ui.test.test_cmd")
-----Mediator引入
require("framework.demo.InstanceMediator")
require("ui.common.TipsMediator")

---@param notification CDemoVO @这个是调用执行发送过来的附加信息，当然也有可能没有参数
_M. StartUpLoginCmd = function(notification)
    lxt("进入登录场景StartUpCmd------>>")
    gFacade.RegisterProxy(CLoginProxy(proxy_enum.LOGIN))
    --注册所需Command
    gFacade.RegisterCommand(Notif.version_return, CommandTable.test_cmd)
    --注册所有的Mediator，这些Mediator由mediator_manager持有。
    gFacade.RegisterUI(UICustomID.Test, CInstanceMediator)
    gFacade.RegisterUI(UICustomID.Tips, CTipsMediator)
    --等待服务器消息改变Proxy，发消息激活Mediator
end

return _M. StartUpLoginCmd