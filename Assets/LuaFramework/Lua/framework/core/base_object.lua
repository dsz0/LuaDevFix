--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: base_object.lua
-- Author: Lorry  created: 2018/2/28 15:15
--[[Description: 对象基类，一般来说，lua的所有对象都可以此为基类，如：Actor, Scene, ui_mediator等
 凡是继承于CBaseObject的对象可使用RegEvent来注册全局事件，
--=====================================================================]]
local Event = require "base.events"
require("base.event_trigger")
---@class CBaseObject @对象基类，方便的注册全局事件，并在销毁时取消所有的注册。
---@field public _name string @测试用对象唯一名
---@field protected _eventList table<string,fun(...):void>@测试用对象唯一名
class "CBaseObject"(function(_ENV)
    --property "_name" { Type = System.String, Default = System.Any }
    --构造函数
    function CBaseObject(self)
        ---@private
        self._eventList = {}
        ---@private
        self._name = "NoName - BaseObject"
    end

    --- GetName 仅仅用于测试Function，在包内部无法被emmyLua智能感知。
    ---@return string
    ---@param self CBaseObject
    function GetName(self)
        return self._name
    end

end)

---RegEvent 注册全局事件监听
---@param self CBaseObject
---@param eventName string
---@param eventFunc func(...):function @在事件发送的时候，第一个参数无法发self，函数编写
function CBaseObject.RegEvent (self, eventName, eventFunc)
    if not eventName or type(eventFunc) ~= "function" then
        return nil
    end
    --Event.AddListener(eventName, eventFunc)
    RegTrigger(eventName, eventFunc)
    table.insert(self._eventList, { eventName = eventName, eventFunc = eventFunc })
    return eventFunc
end

---UnRegEvent 移除全局事件监听
---@param self CBaseObject
---@param eventName System.String
---@param eventFunc System.Delegate
function CBaseObject.UnRegEvent(self, eventName, eventFunc)
    if not eventName then
        return
    end
    --Event.RemoveListener(eventName, eventFunc)
    UnRegTrigger(eventName, eventFunc)
    --下面是为了能够更好的处理对象销毁时，自动释放全部监听事件。
    local removeIndex = {}
    if type(eventFunc) == "function" then
        for k, v in ipairs(self._eventList) do
            if v.eventName == eventName and v.eventFunc == eventFunc then
                table.insert(removeIndex, k)
            end
        end
    else
        for k, v in ipairs(self._eventList) do
            if v.eventName == eventName then
                table.insert(removeIndex, k)
            end
        end
    end

    local len = #removeIndex
    if len > 0 then
        for i = len, 1, -1 do
            table.remove(self._eventList, removeIndex[i])
        end
    end
end

---_ReleaseAllEvent 释放自己监听的所有全局事件
---@param self CBaseObject
---@private @由Destroy函数调用，一般外部不会使用。设为private后对象后不提示函数。
function CBaseObject._ReleaseAllEvent(self)
    for k, v in ipairs(self._eventList) do
        --Event.RemoveListener(v.eventName, v.eventFunc)
        UnRegTrigger(v.eventName, v.eventFunc)
    end
    self._eventList = {}
end

---OnRemove 处理对象销毁时，所有监听的释放。
---@param self CBaseObject
---@public @销毁由管理器统一调用，一般外部不会使用。
function CBaseObject.OnRemove (self)
    self:_ReleaseAllEvent()
end

---Destroy 处理对象销毁，所有的子类都会要重写此函数，如果调用了基类就报错。
---@public
function CBaseObject.Destroy(self)
    error("Destroy-BaseObject->" .. self:GetName())
end
