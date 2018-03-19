--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: test_cmd.lua
-- Author: Lorry  created: 2018/3/7  11:58
--[[Description: command类，一个Mediator操作本身持有的view和proxy是不通过command的。
但是如果要操作其他Mediator和本身不持有的proxy，就需要通过command了。command可随意使用Proxy和发送Message DoCmd
--=====================================================================]]
local _M = CommandTable or {}
CommandTable = _M;
---@type Notif
local Notif = require("common.notif_enum")

---@param vo resp_version_return_vo @这个是调用执行发送过来的附加信息，也可能没参数
_M. test_cmd = function(vo)
    if vo == nil then
        print("test_cmd function execute:")
        return
    end
    assert(vo.version == "Hello world", "vo.version Wrong!!!" )
    assert(vo.buildID == 108 , vo.buildID .. "vo.buildID wrong!!!")
    gFacade.SendMessage(Notif.UPDATE_MESSAGE, "终于跑通了流程！")
end

return _M.test_cmd
