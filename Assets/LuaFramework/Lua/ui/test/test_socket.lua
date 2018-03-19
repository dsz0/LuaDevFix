_G.PLOOP_DEBUG_MODE = true
require "PLoop.init"
----print(PLoop.System)
import "System"

--require("framework.facade")

---M
require "common.global_enum"
local CProtocol = require "logic/net/protocol_base"
--Import各个模块的协议接口--BEGIN
require "common/net_cmd/protocol_test"

local Notif = require("common.notif_enum")
local proxy_enum = require("common.proxy_enum")
require("ui.login.LoginProxy")

---V
require("ui.test.test_mediator")

---C
require "ui.test.test_cmd"

local Event = require "base.events"
require("base.event_trigger")

---@class TestSocket
TestSocket = {}
---FuncTest
---@param buffer LuaFramework.ByteBuffer
function TestSocket.FuncTest(buffer)
    ---@type Network

    gNet = require("logic.Network")
    gNet.Start()
    -- 测试用
    -- AppConst.SocketPort = 7871;
    -- AppConst.SocketAddress = "127.0.0.1";
    -- networkMgr:SendConnect()

     -- test1
    local vo1 = req_test1_vo()
    vo1.param = 2147483641
    -- test2
    local vo2 = req_test2_vo()
    vo2.param = "发的考看了j4w3olsdafjdklth大家提问和"
    -- test3
    local vo3 = req_test3_vo()
    --int64在lua上以string或int64.new(string)表示,直接写不一定会报错,但是数值会错误!!!
    vo3.param1 = int64.new("9223372036854775807")--建议写法1
    -- vo3.param1 = "9223372036854775807"--建议写法2
    -- vo3.param1 = 922337--数值比较小可以这样写,如果不确定不建议这样写
    vo3.param2 = 4
    vo3.param3 = "长度50的字符串sdf"
    vo3.param4 = 1
    vo3.param5 = 16

    -- test4
    local vo4 = req_test4_vo()
    vo4.num = 2
    for i=1,vo4.num do
        vo4.list[i] = 100 - i
    end
    

    -- test5
    local vo5 = req_test5_vo()
    vo5.num = 10

    for i=1,vo5.num do
        vo5.RequestStructData[i] = {}
        vo5.RequestStructData[i].param1 = 1000 + i
        vo5.RequestStructData[i].param2 = 200 + i
    end

    gNet.SendMessage(vo1)
    gNet.SendMessage(vo2)
    gNet.SendMessage(vo3)
    gNet.SendMessage(vo4)
    gNet.SendMessage(vo5)
end
