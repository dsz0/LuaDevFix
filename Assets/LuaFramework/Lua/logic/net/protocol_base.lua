--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: protocol.lua
-- Author: Lorry  created: 2018/3/5  20:09
--[[Description: 处理所有的网络消息,基础协议，连接
--=====================================================================]]

local Notif = require("common.notif_enum")

-- 声明，这里声明了类名还有属性，并且给出了属性的初始值。
---@class CProtocol
CProtocol = {}
--这句是重定义元表的索引，有了这句才是一个类。
CProtocol.__index = CProtocol

---new 构造体，习惯性写为new() Emmylua会感应。
function CProtocol.new()
    local self = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(self, CProtocol);  --将self的元表设定为Class
    return self;    --返回自身
end

local CProtocol = CProtocol

--当连接建立时--
function CProtocol.OnConnect(self)
    print("----------<CProtocol.OnConnect >---------------")
    gFacade.DoCmd(Notif.OnConnect)
end

--连接中断，或者被踢掉--
function CProtocol.OnDisconnect(self)
    print("----------<CProtocol.OnDisconnect>---------------")
    --调用UIMgr弹出断开连接提示。
end

--异常断线--
function CProtocol.OnException(self)
    print("----------<CProtocol.OnException>---------------")
end

return CProtocol
