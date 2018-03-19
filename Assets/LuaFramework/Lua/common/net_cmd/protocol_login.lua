--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: protocol_login.lua
-- Author: Lorry  created: 2018/3/5  20:09
--[[Description: 自动生成login协议处理类，自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
成员变量采用驼峰写法命名，直接访问。
--=====================================================================]]
local proxy_enum = require "common/proxy_enum"
local CProtocol = require "logic/net/protocol_base"
local Notif = require "common/notif_enum"

----------------------------------------------------------------------------------------------------------------------------
--Protocol:19000 version_return 协议,预留协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_version_return_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public encodeType string @编码方式，默认UTF-8，成员变量采用驼峰写法命名，直接访问
---@field public version string @版本号
---@field public buildID number @编译序列号(另一个版本号)
local resp_version_return_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_version_return_vo
function resp_version_return_vo.Parser(buffer)
    ---@type resp_version_return_vo
    local vo = {}
    vo.encodeType = buffer:ReadString()
    vo.version = buffer:ReadString()
    vo.buildID = buffer:ReadInt()
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_version_return(self,buffer)
    local  tempVO = resp_version_return_vo.Parser(buffer)
    local Proxy = gFacade.RetrieveProxy(proxy_enum.version_return)
    if Proxy ~= nil then
        if Proxy.SetData_version_return ~= nil then
            Proxy:SetData_version_return(tempVO)
        else
            logWarn("Proxy[".. proxy_enum.version_return .. "]SetData_version_return not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都不存储，只用一次。所以还是传递过去。
    ---另外这里是自动生成的代码，不知道到底是command还是Mediator来处理所以用SendNotification
    gFacade.SendNotification(Notif.version_return, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_version_return_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public localVersion string @版本号,成员变量采用驼峰写法命名，直接访问
class "req_version_return_vo"(function(_ENV)
    function req_version_return_vo(self)
        self.pid = 19000
        self.localVersion = "0.0.0"
    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_version_return_vo @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_version_return_vo.toByteBuffer(self)
    local buffer = LuaFramework.ByteBuffer.New()
    buffer:WriteInt(self.pid)
    buffer:WriteString(self.localVersion)

    return buffer
end



----------------------------------------------------------------------------------------------------------------------------
--Protocol:180003 游戏公告 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test1_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|String50  @length:50 长度50的字符串
local resp_public_msg_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test1_vo
function resp_public_msg_vo.Parser(buffer)
    ---@type resp_public_msg_vo
    local vo = {}
    vo.pid = 180003
    vo.newstitle = buffer:ReadString(80)
    vo.newspaper = buffer:ReadString(4000)
    vo.flag = buffer:ReadBoolean()
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_public_msg(self,buffer)

    local  tempVO = resp_public_msg_vo.Parser(buffer)

    xrbPrint_r("180003 ____  lua解析协议测试 req_public_msg", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.public_msg)
    if Proxy ~= nil then
        if Proxy.SetData_public_msg ~= nil then
            Proxy:SetData_public_msg(tempVO)
        else
            xrb("Proxy[".. proxy_enum.public_msg .. "]SetData_test1 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.public_msg, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test1 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param number|Int32 @length:4 测试参数1
class "req_public_msg"(function(_ENV)
    function req_public_msg(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["180003"].socket_type
        self.size = rcpc_func_table["180003"]["req_socket_size"]
        self.pid = 180003
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.param = 0

    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test1 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_public_msg.toByteBuffer(self)
    -- -- if check then
    -- --     checkInt64()
    -- -- end
    local otherParam = req_getOtherParamTab("180003", self)
    -- 固定部分
    local buffer = LuaFramework.RazByteBuffer.New()
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.size))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.pid))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.ctxId))
    -- rcpc_func_table 的 key值为协议号,string格式
    -- 协议请求参数(可能为空)
    WriteBufferByTab(otherParam, buffer)
    return buffer
end



----------------------------------------------------------------------------------------------------------------------------
--Protocol:180002 游戏公告 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test1_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|String50  @length:50 长度50的字符串
local resp_server_list_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test1_vo
function resp_server_list_vo.Parser(buffer)
    ---@type resp_server_list_vo
    local vo = {}
    vo.pid = 180002
    vo.num = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.ServerInfo = {}
    for i=1,vo.num do
        vo.ServerInfo[i] = {}
        vo.ServerInfo[i].zoneId = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
        vo.ServerInfo[i].playerLevel = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
        vo.ServerInfo[i].name = buffer:ReadString(24)
        vo.ServerInfo[i].backupDomain = buffer:ReadString(40)
        vo.ServerInfo[i].defaultDomain = buffer:ReadString(40)
        vo.ServerInfo[i].status = buffer:ReadBoolean()
        vo.ServerInfo[i].newserver = buffer:ReadBoolean()
        vo.ServerInfo[i].recommed = buffer:ReadBoolean()
        vo.ServerInfo[i].zoneStatus = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
        vo.ServerInfo[i].lastLogoutTime = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    end
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_server_list(self,buffer)

    local  tempVO = resp_server_list_vo.Parser(buffer)

    xrbPrint_r("180002 ____  lua解析协议测试 req_server_list", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.server_list)
    if Proxy ~= nil then
        if Proxy.SetData_server_list ~= nil then
            Proxy:SetData_server_list(tempVO)
        else
            xrb("Proxy[".. proxy_enum.server_list .. "]SetData_test1 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.server_list, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test1 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param number|Int32 @length:4 测试参数1
class "req_server_list"(function(_ENV)
    function req_server_list(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["180002"].socket_type
        self.size = rcpc_func_table["180002"]["req_socket_size"]
        self.pid = 180002
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.param = 0

    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test1 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_server_list.toByteBuffer(self)
    -- -- if check then
    -- --     checkInt64()
    -- -- end
    local otherParam = req_getOtherParamTab("180002", self)
    -- 固定部分
    local buffer = LuaFramework.RazByteBuffer.New()
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.size))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.pid))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.ctxId))
    -- rcpc_func_table 的 key值为协议号,string格式
    -- 协议请求参数(可能为空)
    WriteBufferByTab(otherParam, buffer)
    return buffer
end




----------------------------------------------------------------------------------------------------------------------------
--Protocol:180008 游戏公告 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test1_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|String50  @length:50 长度50的字符串
local resp_login_check_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test1_vo
function resp_login_check_vo.Parser(buffer)
    ---@type resp_login_check_vo
    local vo = {}
    vo.pid = 180008
    vo.zoneId = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.time = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.zoneCount = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.zoneName = buffer:ReadString(24)
    vo.backupDomain = buffer:ReadString(40)
    vo.defaultDomain = buffer:ReadString(40)
    vo.userId = buffer:ReadString(64)
    vo.sign = buffer:ReadString(32)
    vo.status = buffer:ReadBoolean()
    vo.zoneStatus = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.newHere = buffer:ReadByte()
    vo.createTime = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.preRegAward = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.param = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_login_check(self,buffer)

    local  tempVO = resp_login_check_vo.Parser(buffer)

    xrbPrint_r("180008 ____  lua解析协议测试 req_login_check", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.login_check)
    if Proxy ~= nil then
        if Proxy.SetData_login_check ~= nil then
            Proxy:SetData_login_check(tempVO)
        else
            xrb("Proxy[".. proxy_enum.login_check .. "]SetData_test1 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.login_check, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test1 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param number|Int32 @length:4 测试参数1
class "req_login_check"(function(_ENV)
    function req_login_check(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["180008"].socket_type
        self.size = rcpc_func_table["180008"]["req_socket_size"]
        self.pid = 180008
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.param = 0

    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test1 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_login_check.toByteBuffer(self)
    -- -- if check then
    -- --     checkInt64()
    -- -- end
    local otherParam = req_getOtherParamTab("180008", self)
    -- 固定部分
    local buffer = LuaFramework.RazByteBuffer.New()
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.size))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.pid))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.ctxId))
    -- rcpc_func_table 的 key值为协议号,string格式
    -- 协议请求参数(可能为空)
    WriteBufferByTab(otherParam, buffer)
    return buffer
end