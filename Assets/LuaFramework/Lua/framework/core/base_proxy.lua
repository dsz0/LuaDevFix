--======================================================================
--（c）copyright 2018 All Rights Reserved
--======================================================================
-- Filename: base_proxy.lua
-- Author: lxt  created: 2018/02/24
-- Description: 所有的Proxy都继承此类,负责模块事件的注册，派发。
---本来准备写个View管理所有Mediator和View(Panel)，思考了一下，还是先直接放facade里面。
-- Mediator可发送Command，接收Message。在初始化时取得对应Proxy实例并保存其引用，避免频繁获取。
--======================================================================
--[[Proxy:数据代理]]

---@class CBaseProxy @代理基类，方便的注册全局事件，并在销毁时取消所有的注册。
---@field public Data any @用于get or  set the data object
---@field protected _proxyName string @the proxy name
class "CBaseProxy" (function(_ENV)
    --property "_name" { Type = System.String, Default = System.Any }
    --构造函数
    --- @return CBaseObject
    function CBaseProxy(self, name)
        self.Data = nil
        self._proxyName = name or "NoName -in BaseProxy"
    end
end)

---GetProxyName 返回注册名称
---@public
---@param self CBaseProxy
function CBaseProxy.GetProxyName(self)
    return self._proxyName
end
