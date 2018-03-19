--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: notif_enum.lua
-- Author: Lorry  created: 2018/2/28 15:15
--[[Description: Facade发送的通知的枚举会变得很大，而且总是修改，和其他枚举分开。
--=====================================================================]]
local ToStr = function (value)
    if (type(value) == "string") then return "\"" .. value .. "\"" end
    return tostring(value)
end

local SetWarnIndex = function (t)
    setmetatable(t, {
        __index = function (t, k)
            local temp = debug.traceback("",2)
            print("Can\'t index not exist key-[" .. ToStr(k) .. "] in " .. tostring(t) .. string.sub(temp, 2, -1))
            return "NoNotif"
        end,
        __newindex = function (t, k, v)
            print("Can\'t newindex not exist key-" .. tostring(t) .. "[" .. ToStr(k) .. "]" .. debug.traceback())
            return "NoNotifExist"
        end,
    })
end

--Facade发送的通知的枚举，其实这个很大，又总是修改，最好和其他枚举分开。
---@class Notif
local ENUM_Notif = {
    ----------------------------------------------------------------------
    -- 基础Controller层消息通知
    START_UP = "StartUp",
    DISPATCH_MESSAGE = "DispatchMessage",

    ----------------------------------------------------------------------
    --- View层消息通知，Facade.SendMessage
    UPDATE_MESSAGE = "UpdateMessage",      --更新消息
    UPDATE_EXTRACT = "UpdateExtract",      --更新解包
    UPDATE_DOWNLOAD = "UpdateDownload",    --更新下载
    UPDATE_PROGRESS = "UpdateProgress",    --更新进度

    OPEN_TEST = "OpenTest",   -- 打开Test界面
    CLOSE_TEST = "CloseTest", -- 关闭Test界面
    UPDATE_TEST = "UpdateTest", -- 更新Test界面信息

    OPEN_TIPS = "OpenTips",   -- 打开Tips界面
    CLOSE_TIPS = "CloseTips", -- 关闭Tips界面

    ----------------------------------------------------------------------
    --- 操作View的Command,这部分工作考虑交给uiManager


    ----------------------------------------------------------------------
    ---Network中CProtocol执行的网络通知，考虑自动生成,请勿随意更改。
    OnConnect = "101",

    -- 测试协议
    test1 = "190001",
    test2 = "190002",
    test3 = "190003",
    test4 = "190004",
    test5 = "190005",

    --登陆
    LOGIN_DATA_UPDATE = "20000",
    LOGIN_VERSION_RETURN = "20001",
    LOGIN_UID_LIST_RETURN = "20002",
    LOGIN_RETURN = "20003",
    version_return = "version_return19000",

    --背包
    BackPack_ADD_POS_UPDATE = "30000",
    BackPack_EQUIP_POS_UPDATE = "30001",
    TemPack_ADD_POS_UPDATE = "30002",
}
SetWarnIndex(ENUM_Notif)

return ENUM_Notif
