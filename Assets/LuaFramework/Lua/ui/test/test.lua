_G.PLOOP_DEBUG_MODE = true
require "PLoop.init"
----print(PLoop.System)
import "System"

--require("framework.facade")

---M
require "common.global_enum"
local CProtocol = require "logic/net/protocol_base"
--Import各个模块的协议接口--BEGIN
require "common/net_cmd/protocol_login"

local Notif = require("common.notif_enum")
local proxy_enum = require("common.proxy_enum")
require("ui.login.LoginProxy")

---V
require("ui.test.test_mediator")

---C
require "ui.test.test_cmd"

local Event = require "base.events"
require("base.event_trigger")

---@class Test
Test = {}
---FuncTest
---@param buffer LuaFramework.ByteBuffer
function Test.FuncTest(buffer)
    ---@type Network

    gNet = require("logic.Network")
    gNet.Start()
    ---@type req_version_return_vo
    local vo = req_version_return_vo()
    vo.localVersion = "Hello World"
    gNet.SendMessage(vo)
    gNet.OnSocket(19000,buffer)
    --local msg1 = buffer:ReadString()
    --local msg2 = buffer:ReadString()
    --local size = buffer:ReadInt()
    --log(debug.tracebackEx())
    --lxt("Main ByteBuffer test", size, msg1, msg2)
end
--Event.AddListener(Notif.version_return, CommandTable.test_cmd);
--Event.Brocast(Notif.version_return)
--
--RegTrigger(Notif.version_return,CommandTable.test_cmd)
--EventTrigger(Notif.version_return)
--CommandTable.test_cmd()
