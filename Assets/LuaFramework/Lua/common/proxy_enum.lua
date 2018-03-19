--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: proxy_enum.lua
-- Author: Lorry  created: 2018/3/5  18:57
--[[Description: 枚举列表，使用 local Enum= require(common.proxy_enum)引入文件使用。
--=====================================================================]]
local ToStr = function(value)
    if (type(value) == "string") then
        return "\"" .. value .. "\""
    end
    return tostring(value)
end

local SetWarnIndex = function(t)
    setmetatable(t, {
        __index = function(t, k)
            logWarn("Can\'t index not exist key-" .. tostring(t) .. "[" .. ToStr(k) .. "]" .. "\n" .. debug.traceback())
        end,
        __newindex = function(t, k, v)
            logWarn("Can\'t newindex not exist key-" .. tostring(t) .. "[" .. ToStr(k) .. "]" .. "\n" .. debug.traceback())
        end,
    })
end

--枚举
---@class proxy_enum @数据代理的枚举名
local proxy_enum = {
    START = "Start",
--测试用数据代理
    LOGIN = "LoginProxy",
    BODY = "Body",
    END = "End",

    ---下面是根据自动生成protocol代码，编写的数据代理枚举(所以才是小写加下划线)。
    ---注意：不是所有protocol传过来的数据都一定要存起来，也有无Proxy的协议。
    heart_beat = "NoProxy",
    ---将多个proxy指向同一个的proxy对象，这样可避免proxy类爆炸，因为protocol代码是自动生成的。
    version_return = "LoginProxy", --proxy_enum.LOGIN
    login_user_id_return = "LoginProxy", --proxy_enum.LOGIN
    login_equip_id_return = "LoginProxy", --proxy_enum.LOGIN

    -- 测试协议
    test1 = "test",
    test2 = "test",
    test3 = "test",
    test4 = "test",
    test5 = "test",
}
SetWarnIndex(proxy_enum)


return proxy_enum
