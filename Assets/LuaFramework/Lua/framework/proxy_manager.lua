--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: proxy_manager.lua
-- Author: Lorry  created: 2018/3/5  16:40
--[[Description: 数据代理管理类，由Facade持有，相当于PureMVC的 Model类。
1.保存所有IProxy的实例。
2.提供注册，获取，移除 IProxy实例的接口。
--=====================================================================]]

---@class CProxyManager @主要用于管理 DataProxy
---@field public _proxyMap table @Mapping of proxyNames to IProxy instances
CProxyManager = {}
local this = CProxyManager

---@return CProxyManager @返回CProxyManager单例，调用第二次会再次初始化，待修改。
function CProxyManager.Instance()
    if this._proxyMap ~=nil then
        return this
    end
    this._proxyMap = {}
    return this
end

---RegisterProxy    注册Register an IProxy instance with the Model.
---@public
---@param  proxyIns IProxy
function CProxyManager.RegisterProxy(proxyIns)
    assert(proxyIns ~= nil)
    --lxt("注册数据代理:", proxyIns:GetProxyName())
    proxyIns:OnRegister();
    this._proxyMap[proxyIns:GetProxyName()] = proxyIns
end

---RetrieveProxy    获得Retrieve an IProxy instance from the Model.
---@param name string
---@return IProxy
function CProxyManager.RetrieveProxy(name)
    --lxt("获取数据代理RetrieveProxy")
    return this._proxyMap[name]
end
---RemoveProxy    销毁Remove an IProxy instance from the Model.
---@param name string
function CProxyManager.RemoveProxy(name)
    ---@type IProxy
    local tempProxy = this.RetrieveProxy(name)
    assert(tempProxy ~=nil, name)
    tempProxy:OnRemove()
    this._proxyMap[name] = nil
end

---HasProxy 是否存在对应的数据代理。
---@param name string
---@return boolean
function CProxyManager.HasProxy(name)
    if this._proxyMap[name] ~= nil then
        return true
    end
    return false
end
