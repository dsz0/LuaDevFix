--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: DemoVO.lua
-- Author: Lorry  created: 2018/3/3  10：38
--[[Description: 自动生成的标准值对象
简单说，ValueObject的值（状态）一旦创建以后就不会改变了。所以可以当基本数据类型用。
1）用于网络协议的接收，发送
2）用于标准配置数据的读取。
--=====================================================================]]

---@class CTestVO
---@field id int
---@field name string
CTestVO = {}

---@class CDemoVO @CDemoVO  数据对象结构Value Object
---@field public name string @自动生成的属性。
---@field public Id long @自动生成的属性。
---@field public bool_isVip boolean @自动生成的属性。
---@field public description string @自动生成的属性。
---@field public someType byte @自动生成的属性
---@field public money number @自动生成的属性
---@field test CTestVO @结构
---@field testList table<string,CTestVO> @
CDemoVO = {}

local temp = CDemoVO
temp.test.name ="test"
temp.testList["100"].id = 100;

--两种方法实现其中一种即可
--解析方法1
---@param buffer LuaFramework.ByteBuffer @网络传递过来的消息
---@return CDemoVO @返回解析好的CDemoVO实例对象table
function CDemoVO.Parser (buffer)
    ---@type CDemoVO
    local vo = {}
    vo.name = buffer:ReadString();
    vo.id = buffer:ReadLong();
    vo.isVip = buffer:ReadByte();
    vo.description = buffer:ReadString();
    vo.someType = buffer:ReadByte();
    vo.money = buffer:ReadDouble();
    return vo;
end

---ToByteBuffer 一般来说接收到的数据，和发送出去的数据是两个结构。应该不存在这种消息。
---@param vo CDemoVO @赋值完成的数据结构
---@return LuaFramework.ByteBuffer @返回CDemoVO解析好的实例对象
function CDemoVO.ToByteBuffer(vo)
    local buffer = LuaFramework.ByteBuffer.New()
    --body 数据转换过程
    return buffer
end


--解析方法2，可以让CDemoVO保持为一个没有函数的纯数据table，等于纯粹用一下注释功能。
local _M = Protocol or {}
Protocol = _M
---ParserCDemoVO
---@param buffer LuaFramework.ByteBuffer @网络传递过来的消息
---@return CDemoVO @返回CDemoVO解析好的实例对象
function Protocol.ParserCDemoVO(buffer)
    local vo = {}
    vo.name = buffer:ReadString();
    vo.id = buffer:ReadLong();
    vo.isVip = buffer:ReadByte();
    vo.description = buffer:ReadString();
    vo.someType = buffer:ReadByte();
    vo.money = buffer:ReadDouble();
    return vo;
end
