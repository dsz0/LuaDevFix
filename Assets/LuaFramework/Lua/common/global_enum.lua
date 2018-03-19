--======================================================================
--（c）copyright 2015 All Rights Reserved
--======================================================================
-- Filename: global_enum.lua
-- Author: lxt  created: 2015/10/29
-- Description: 需要在不同模块使用的公共枚举变量存储文件
--======================================================================
local ToStr = function (value)
    if (type(value) == "string") then return "\"" .. value .. "\"" end
    return tostring(value)
end

local SetErrorIndex = function (t)
    setmetatable(t, {
        __index = function (t, k)
            error("Can\'t index not exist key-" .. tostring(t) .. "[" .. ToStr(k) .. "]" .. "\n" .. debug.traceback())
        end,
        __newindex = function (t, k, v)
            error("Can\'t newindex not exist key-" .. tostring(t) .. "[" .. ToStr(k) .. "]" .. "\n" .. debug.traceback())
        end,
    })
end

---@class UICustomID @频繁打开的UI的ID
UICustomID = {
    Test = 'Test',
    -- 登录
    Login = "Login",
    Server = "Server",
    -- 主界面,主城界面，战斗界面
    MainCity = "MainCity",
    FightMain = "FightMain",
    --通用界面
    Tips = "Tips",
    PnlTipsWithBtn = "PnlTipsWithBtn",
    PnlTipsNoBtn = "PnlTipsNoBtn",
    --背包界面
    BackPack = "BackPack",
    TemPack = "TemPack",
    -- 任务及聊天界面
    Task = "Task",
    Chat = "Chat",
}
SetErrorIndex(UICustomID)


ITEM_BAG_EQUIP = { --装备的使用位置
    BAG_EQUIP_START = 1,
    BAG_EQUIP_END = 8,
}
SetErrorIndex(ITEM_BAG_EQUIP)


__init__ = function (mod)
    loadglobally(mod)
end
