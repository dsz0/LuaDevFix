--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: IMediator.lua
-- Author: Lorry  created: 2018/2/28
-- Description: IMediator接口类，子类必须实现相关接口,不过这里暂时只用于提示。
--======================================================================

--接口
---@class IMediator
interface "IMediator" (function(_ENV)
    --[[继承者OnRegister方法，在这里决定IMediator监听的方法,
    -- __DebugRequire__() --这个方法原本用于强制子类实现，现已废弃。
    ---OnRegister 在注册时调用 -OnRemove在BaseObject中实现了
    ---@see CMediatorManager#_RegisterMediator
    ---@param self IMediator
    --function OnRegister(self)
    --end

    ---Destroy 在销毁时调用此函数
    ---@see CMediatorManager#Destroy
    ---@param self IMediator
    --function OnDestroy(self)
    --end]]
end)

---Destroy 在销毁时调用此函数
---@see CMediatorManager#Destroy
---@param self IMediator
function IMediator.Destroy(self)
end

---OnRegister 在注册时调用 -OnRemove在BaseObject中实现了
---@see CMediatorManager#_RegisterMediator
---@param self IMediator
function OnRegister(self)
end

---OnRemove 在销毁时调用此函数，不过所有Mediator的OnRemove都在BaseObject中实现了。
---@see CMediatorManager#RemoveMediator
---@see CMediatorManager#Clear
---@param self IMediator
function OnRemove(self)
end
