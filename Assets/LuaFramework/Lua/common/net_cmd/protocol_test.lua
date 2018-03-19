--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- Filename: protocol_test.lua
-- Author: Lorry  created by nettool: 2018/3/5  20:09
--[[Description: 自动生成test协议处理类，自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
成员变量采用驼峰写法命名，直接访问。
--=====================================================================]]
local proxy_enum = require "common/proxy_enum"
local CProtocol = require "logic/net/protocol_base"
local Notif = require "common/notif_enum"

local rcpc_func_table = require "common/net_cmd/rpc_lua_table"
----------------------------------------------------------------------------------------------------------------------------
--Protocol:190001 test1 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test1_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|String50  @length:50 长度50的字符串
local resp_test1_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test1_vo
function resp_test1_vo.Parser(buffer)
    ---@type resp_test1_vo
    local vo = {}
    vo.pid = 190001
    vo.param = buffer:ReadString(50)
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_test1(self,buffer)
    local  tempVO = resp_test1_vo.Parser(buffer)

    xrbPrint_r("resp_test1", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.test1)
    if Proxy ~= nil then
        if Proxy.SetData_test1 ~= nil then
            Proxy:SetData_test1(tempVO)
        else
            xrb("Proxy[".. proxy_enum.test1 .. "]SetData_test1 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.test1, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test1 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param number|Int32 @length:4 测试参数1
class "req_test1_vo"(function(_ENV)
    function req_test1_vo(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["190001"].socket_type
        self.size = rcpc_func_table["190001"]["req_socket_size"]
        self.pid = 190001
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.param = 0

    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test1 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_test1_vo.toByteBuffer(self)
    -- -- if check then
    -- --     checkInt64()
    -- -- end
    local otherParam = req_getOtherParamTab("190001", self)
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
--Protocol:190002 test2 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test2_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|String100  @length:100 长度100的字符串
local resp_test2_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test2_vo
function resp_test2_vo.Parser(buffer)
    ---@type resp_test2_vo
    local vo = {}
    vo.pid = 190002
    vo.param = buffer:ReadString(100)
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_test2(self,buffer)
    local  tempVO = resp_test2_vo.Parser(buffer)

    -- print_r 打印table用函数
    xrbPrint_r("resp_test2", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.test2)
    if Proxy ~= nil then
        if Proxy.SetData_test2 ~= nil then
            Proxy:SetData_test2(tempVO)
        else
            xrb("Proxy[".. proxy_enum.test2 .. "]SetData_test2 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.test2, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test2 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param string(string length:50) @长度50的字符串
class "req_test2_vo"(function(_ENV)
    function req_test2_vo(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["190002"].socket_type
        self.size = rcpc_func_table["190002"]["req_socket_size"]
        self.pid = 190002
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.param = ""

    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test2 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_test2_vo.toByteBuffer(self)
    -- 数据合法性检查
    -- assert(string.len(self.param1) < 50)-- Int32类型长度检查
    -- assert(string.len(self.param) < 50)-- string类型长度检查

    -- -- 固定部分
    -- local buffer = LuaFramework.RazByteBuffer.New()
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.size))
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.pid))
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.ctxId))
    -- -- rcpc_func_table 的 key值为协议号,string格式
    -- -- 协议请求参数(可能为空)
    -- buffer:WriteStringWithLen(self.param, 50)

    local otherParam = req_getOtherParamTab("190002", self)
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
--Protocol:190003 test3 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test3_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|String50  @length:50 长度50的字符串
local resp_test3_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test3_vo
function resp_test3_vo.Parser(buffer)
    ---@type resp_test3_vo
    local vo = {}
    vo.pid = 190003
    vo.bool = buffer:ReadBoolean()
    vo.msg = buffer:ReadString(100)
    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_test3(self,buffer)
    local  tempVO = resp_test3_vo.Parser(buffer)

    -- print_r 打印table用函数
    xrbPrint_r("resp_test3", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.test3)
    if Proxy ~= nil then
        if Proxy.SetData_test3 ~= nil then
            Proxy:SetData_test3(tempVO)
        else
            xrb("Proxy[".. proxy_enum.test3 .. "]SetData_test3 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.test3, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test3 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param1 string|Int64  @length:8 lua没有原生支持Int64,使用一个lua Int64库,在lua上用string表示
---@field public param2 number|Int32  @length:4 客户端固定为0
---@field public param3 string|string  @length:50 长度50的字符串
---@field public param4 number|Int8  @length:1 客户端固定为0
---@field public param5 number|Int16  @length:2 客户端固定为0
class "req_test3_vo"(function(_ENV)
    function req_test3_vo(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["190003"].socket_type
        self.size = rcpc_func_table["190003"]["req_socket_size"]
        self.pid = 190003
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.param1 = "0" -- int64在lua上以string或userdata表示
        self.param2 = 0
        self.param3 = "长度50的字符串"
        self.param4 = 0
        self.param5 = 0
    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test3 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_test3_vo.toByteBuffer(self)
    -- -- 固定部分
    local otherParam = req_getOtherParamTab("190003", self)
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
--Protocol:190004 test4 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test4_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|string  @length:50 长度50的字符串
local resp_test4_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test4_vo
function resp_test4_vo.Parser(buffer)
    ---@type resp_test4_vo
    local vo = {}
    vo.pid = 190004
    vo.num = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.msg = buffer:ReadString(100)
    vo.list = {}
    for i=1,vo.num do
        vo.list[i] = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    end

    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_test4(self,buffer)
    local  tempVO = resp_test4_vo.Parser(buffer)

    -- print_r 打印table用函数
    xrbPrint_r("resp_test4", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.test4)
    if Proxy ~= nil then
        if Proxy.SetData_test4 ~= nil then
            Proxy:SetData_test4(tempVO)
        else
            xrb("Proxy[".. proxy_enum.test4 .. "]SetData_test4 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.test4, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test4 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param int @版本号,成员变量采用驼峰写法命名，直接访问
class "req_test4_vo"(function(_ENV)
    function req_test4_vo(self)
        -- 固定部分
        self.socket_type = rcpc_func_table["190004"].socket_type
        self.size = rcpc_func_table["190004"]["req_socket_size"]
        self.pid = 190004
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.num = 0
        self.list = {}
    end
end)

---toByteBuffer 解析给NetWork发送
---@param self req_test4 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_test4_vo.toByteBuffer(self)
    local otherParam = req_getOtherParamTab("190004", self)
    -- 固定部分
    local buffer = LuaFramework.RazByteBuffer.New()
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.size))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.pid))
    buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.ctxId))
    -- rcpc_func_table 的 key值为协议号,string格式
    -- 协议请求参数(可能为空)
    WriteBufferByTab(otherParam, buffer)


    -- -- 数据错误或协议长度可变,只能在数据传入的时候开始算
    -- local type_size = {}
    -- type_size["Bool"] = 1
    -- type_size["Signed8"] = 1
    -- type_size["Signed16"] = 2
    -- type_size["Signed32"] = 4
    -- type_size["Signed64"] = 8

    -- local MIN_SIZE = 12
    -- if type(self.size) ~= "number" or self.size < MIN_SIZE then
    --     local size = 12
    --     for _,tab in pairs(rcpc_func_table["190004"]["req_args"]) do
    --         local keySize = 0
            
    --         if type_size[tab.type] then
    --             keySize = type_size[tab.type]
    --         else
    --             xrb("tab.type =====> " .. tab.type)

    --             local strNum = string.match(tab.type, "UTF8String[(.-)]")
    --             if  strNum and strNum > 0 then
    --                 xrb("strNum =====> " .. strNum)
    --                 keySize = strNum
    --             end

    --             local Signed32Num = string.match(tab.type, "Signed32%[(.-)%]")
    --             xrb("Signed32Num =====> " .. Signed32Num)
    --             if tonumber(Signed32Num) then
    --                 xrb("tonumber(Signed32Num) =====> " .. tonumber(Signed32Num))
    --                 keySize = tonumber(Signed32Num)
    --             elseif string.find(Signed32Num, "%$") then
    --                 local str = string.gsub(Signed32Num, "%$", "")
    --                 xrb('string.find(Signed32Num, "%$") =====> ' .. str)
    --                 if type(self[str]) == "number" then
    --                     xrb('self[str] =====> ' .. self[str])
    --                     keySize = self[str] * 4
    --                 else
    --                      logError("self[str] is not number !!!!!!!!! =====> " .. self[str])
    --                 end
    --             end

    --         end

    --         xrb(tab.type .. "-keySize:" .. keySize)

    --         -- assert(0 == keySize, "wrong to size ... key:" .. tab.key .. ", type:" .. tab.key)
    --         size = size + keySize
    --     end
    --     self.size = size
    -- end

    -- -- 固定部分
    -- local buffer = LuaFramework.RazByteBuffer.New()
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.size))
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.pid))
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.ctxId))
    -- -- rcpc_func_table 的 key值为协议号,string格式
    -- -- 协议请求参数(可能为空)
    -- buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.num))
    -- for i=1,self.num do
    --     buffer:WriteInt32(RazConverter.GetBigEndian_Int32(self.list[i]))
    -- end

    return buffer
end



----------------------------------------------------------------------------------------------------------------------------
--Protocol:190005 test5 协议
----------------------------------------------------------------------------------------------------------------------------
--下行客户端接收协议
---@class resp_test5_vo @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public size number|Int32  @length:4 协议长度
---@field public pid number|Int32  @length:4 协议号
---@field public ctxId number|Int32  @length:4 客户端固定为0
---@field public param string|string  @length:50 长度50的字符串
local resp_test5_vo = {}

---Parser 网络消息解析函数
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
---@return cli_test5_vo
function resp_test5_vo.Parser(buffer)
    ---@type resp_test5_vo
    -- local otherParam = req_getOtherParamTab("190005")
    -- 读
    local vo = {}
    vo.pid = 190005
    vo.num = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
    vo.list = {}
    for i=1,vo.num do
        vo.list[i] = {}
        vo.list[i].param1 = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
        vo.list[i].param2 = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
        vo.list[i].paramList = {}
        for j=1,10 do
            vo.list[i].paramList[j] = RazConverter.GetBigEndian_Int32(buffer:ReadInt())
        end
    end

    return vo
end

--@param id number @协议号
---@param buffer LuaFramework.ByteBuffer @服务器传过来的二进制信息流
function CProtocol.resp_test5(self,buffer)
    local  tempVO = resp_test5_vo.Parser(buffer)

    -- print_r 打印table用函数
    xrbPrint_r("resp_test5", tempVO)

    local Proxy = gFacade.RetrieveProxy(proxy_enum.test5)
    if Proxy ~= nil then
        if Proxy.SetData_test5 ~= nil then
            Proxy:SetData_test5(tempVO)
        else
            xrb("Proxy[".. proxy_enum.test5 .. "]SetData_test5 not Implement")
        end
    end
    ---其实这里可以不传tempVO,因为获得Proxy就可以得到数据，这是Proxy的用途
    ---但是因为不少网络数据包，都用不着存储，只用一次。所以还是传递过去……
    gFacade.SendNotification(Notif.test5, tempVO)
end

----------------------------------------------------------------------------------------------------------------------------
---上行服务器请求协议,成员变量pid自动必须自动生成,
--- 所有成员变量初始化，构造函数最好有默认值，不然使用时，需要自己赋值，容易出错。
---@class req_test5 @自动生成的数据结构体用纯小写加下划线，与火箭写法的类class分开
---@field public param int @版本号,成员变量采用驼峰写法命名，直接访问
class "req_test5_vo"(function(_ENV)
    function req_test5_vo(self)
        self.socket_type = rcpc_func_table["190005"].socket_type
        -- 固定部分
        self.size = rcpc_func_table["190005"]["req_socket_size"]
        self.pid = 190005
        self.ctxId = 0
        -- 协议请求参数,这里可以填上默认值(可为空)
        self.num = 0
        self.RequestStructData = {}
        -- self.RequestStructData[i].param1 = 0
        -- self.RequestStructData[i].param2 = 0
    end
end)


-- 测试用协议解析,测试通过后统一写成公共方法调用,主要是解决结构体嵌套的情况
function table_is_empty(t)
    return _G.next( t ) == nil
end

function test_calculateSize(settingTab, otherParam, self)
    local converterValue = 
    {
        ["Bool"] = function(value)
            return value
        end,
        ["Signed8"] = function(value)
            return value
        end,
        ["Signed16"] = function(value)
            return RazConverter.GetBigEndian_Int16(value)
        end,
        ["Signed32"] = function(value)
            return RazConverter.GetBigEndian_Int32(value)
        end,
        ["Signed64"] = function(value)
            return RazConverter.GetBigEndian_Int64(value)
        end,
        ["UTF8String[50]"] = function(value)
            local t = {}
            t.value = value
            t.len = 50
            return t
        end,
        ["UTF8String[100]"] = function(value)
            local t = {}
            t.value = value
            t.len = 100
            return t
        end,

        -- 考虑是不是要直接这样写,简单暴力
        -- ["Signed32[$num]"] = function(value)
        --     -- buffer:WriteStringWithLen(value.str, value.len)
        -- end,
    }

    local type_size = {}
    type_size["Bool"] = 1
    type_size["Signed8"] = 1
    type_size["Signed16"] = 2
    type_size["Signed32"] = 4
    type_size["Signed64"] = 8
    type_size["UTF8String[50]"] = 50
    type_size["UTF8String[100]"] = 100
    --true值表示该值可以正常处理,但是依赖于别的数据(此数据有可能不存在,所以下面再赋值)
    type_size["Signed32[$num]"] = true 

    local size = 0

    local normalhandle = function(stype, stab, skey)
        -- xrb("stype::skey" .. stype .. "::" ..  skey)
        -- 计算size值
        size = size + type_size[stype]
        -- 处理otherParam配置值
        local t = {}
        t.type = stype
        -- t.value = converterValue[stype](stab[tabkey])
        -- print("============= stab ===========")
        -- print_r(stab)
        -- print("============= stab ===========")

        t.value = (converterValue[stype])(stab[skey])
        table.insert(otherParam, t)
    end


    
    local num = #settingTab
    xrb("#settingTab:" .. #settingTab)

    for i=1,num do
        if type_size[settingTab[i].type] then
            -- 数组处理
            if settingTab[i].type == "Signed32[$num]" then
                local stype = settingTab[i].type
                -- 长度已经算完
                size = size + self.num * 4

                -- 开始组装数据
                local Signed32TabNum = self.num
                for j=1,Signed32TabNum do
                    local t = {}
                    t.type = "Signed32"
                    -- 190004的 self[settingTab[i].key] ~ self.list
                    local v = self[settingTab[i].key][j]
                    -- xrb("v::::::::" .. v)
                    t.value = (converterValue["Signed32"])(v)
                    table.insert(otherParam, t)
                end
            else
                -- 单个变量处理
                normalhandle(settingTab[i].type, self, settingTab[i].key)
            end
        elseif settingTab[i].struct and not table_is_empty(settingTab[i].struct) then
            -- 结构体变量处理(暂不支持结构体嵌套)
            -- 这里特别说明一下,struct数组先是从数据table里面拿到第一个结构体,然后再配置表里面循环操作
            local selfKey = settingTab[i].key
            local selfKeyNum = self["num"]--这里简化了一步,应该是从type里面获取到底在哪里获得num值
            for j=1,selfKeyNum do
                local strucNum = #settingTab[i].struct
                -- print("============= strucNum ============ " .. strucNum)
                -- print("============= selfKey ============ " .. selfKey)
                for k=1,strucNum do
                    normalhandle(settingTab[i].struct[k].type, self[selfKey][k], settingTab[i].struct[k].key)
                end
            end
        else
            -- 以下是特殊类型处理
            -- 或者考虑在converterValue简单暴力的写
        end
    end

    xrbPrint_r("otherParam", otherParam)

    return size
end

function WriteBufferByTab(otherParam, buffer)
    local bufferW = 
    {
        ["Bool"] = function(value)
            buffer:WriteByte(value)
        end,
        ["Signed8"] = function(value)
            buffer:WriteInt8(value)
        end,
        ["Signed16"] = function(value)
            buffer:WriteInt16(value)
        end,
        ["Signed32"] = function(value)
            buffer:WriteInt32(value)
        end,
        ["Signed64"] = function(value)
            buffer:WriteInt64(value)
        end,
        ["UTF8String[50]"] = function(valueTab)
            buffer:WriteStringWithLen(valueTab.value, valueTab.len)
        end,
        ["UTF8String[100]"] = function(value)
            buffer:WriteStringWithLen(valueTab.value, valueTab.len)
        end,
    }
    

    local tabnum = #otherParam
    for i=1,tabnum do
        bufferW[otherParam[i].type](otherParam[i].value)
    end
end

-- 根据配置表获取数据
function req_getOtherParamTab(pid, self)
    local settingTab = rcpc_func_table[tostring(pid)]["req_args"]

    if settingTab == nil or table_is_empty(settingTab) then
        xrb('rcpc_func_table["' .. pid .. '"].resp_args is nil! 此协议没有请求参数')
        settingTab = {}
    end

    local otherParam = {}--整理buffer需要写入的值,tab数组,tab.type,tab.value
    
    -- 判断是否需要重新计算
    -- 这里开始重新计算size值,数据错误或协议长度可变,只能在数据传入的时候开始算
    local size = 12
    -- 一边计算size值，一边整理otherParam,结构上只有一层数组,按顺序写入
    size = size + test_calculateSize(settingTab, otherParam, self)

    local MIN_SIZE = 12--这个考虑放到公共类全局变量,注意变量名不要和其它重复了
    if type(self.size) ~= "number" or self.size < MIN_SIZE then
        xrb('rcpc_func_table["' .. pid .. '"].req_socket_size 不是合法值:' .. self.size .. ', 请检查是否配置错了数值!(协议长度不固定可忽略此条警告)')
    elseif self.size ~= size then
        logError('rcpc_func_table["' .. pid .. '"].req_socket_size值和计算值不同:' .. self.size .. " ~ " .. size .. ', 请检查是否配置错了长度数值或长度计算错误!')
    end

    self.size = size
    return otherParam
end

---toByteBuffer 解析给NetWork发送
---@param self req_test1 @version请求数据结构
---@return LuaFramework.ByteBuffer @返回给NetWork发送
function req_test5_vo.toByteBuffer(self)
    local otherParam = req_getOtherParamTab("190005", self)

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

