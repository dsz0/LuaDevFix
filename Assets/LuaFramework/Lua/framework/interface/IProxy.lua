--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: IProxy.lua
-- Author: Lorry  created: 2018/3/5 17:35
-- Description: IProxy接口类，子类必须实现相关接口,不过这个类现在只用于做提示。
--======================================================================

--接口
---@class IProxy
---@field public _name string @IProxy的名字
---@field public Data any @Proxy操作的数据VO
interface "IProxy" (function(_ENV)
    --继承者OnRegister方法，在这里决定IMediator监听的方法,
    -- __DebugRequire__() --这个方法原本用于强制子类实现，现已废弃。
end)

---OnRegister 在注册时调用
---@see CMediatorManager#_RegisterMediator
---@param self IMediator
function IProxy.OnRegister(self)
end

---Destroy 在销毁时调用此函数
---@see CMediatorManager#Destroy
---@param self IMediator
function IProxy.OnRemove(self)
end


---GetProxyName 获得代理的名字
---@param self IProxy
function IProxy.GetProxyName(self)
end

---SetData  @设置代理持有的vo对象
---@param self IProxy
---@param vo any
function IProxy.SetData(self, vo)
end