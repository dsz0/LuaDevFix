--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- filename: facade.lua
-- author: lorry  created: 2018/02/22
-- descrip: 完成MVC相关重要操作，不过因为lua的特性原因，所以写法和C#有不同。
-- 全局单例完全用不着，不过决定交给game.lua持有。
-- Mediator可发送Command，接收Message。在初始化时取得对应Proxy实例并保存其引用，避免频繁获取。
--======================================================================
--require "ui/ui_manager"
require("framework.mediator_manager")
require("framework.proxy_manager")
--- 暂时废弃用于发送UIMediator所需的事件广播
--local Event = require "base.events"
--- Command部分现在使用event_trigger的RegTrigger 和 UnRegTrigger
---主要因为使用Event时，assert和exception报错都无法成功。
require "base/event_trigger"
---@class Facade
Facade = {}
local this = nil

---@return Facade @这就是一个最简洁的单例,所有函数调用都不用 : 而是使用 . 因为用不着传入self
function Facade.Instance()
    if this ~=nil then
        return this
    end
    this = Facade
    ---@type CMediatorManager
    this._mediatorMgr = CMediatorManager.Instance();
    this._proxyMgr = CProxyManager.Instance();
    -- 这里可以考虑进行Command的注册
    this._cmdList = {}
    return this
end

---DoCmd --主要被Mediator和Cmd类调用
---@param cmdName string @在 global_enum中定义的
---@param ... any @传递Controller的变长参数
function Facade.DoCmd (cmdName, ...)
    if (this._cmdList[cmdName] ~= nil) then
        EventTrigger(cmdName,...)
        --Event.Brocast(tostring(cmdName), ...)
    else
        lxt("执行了未注册的Cmd : " .. cmdName)
    end
end

---SendMessage  由Command调用，Mediator不调用。主要是希望Mediator不与其他Mediator产生关系。
---@param cmdName string @在
function Facade.SendMessage (cmdName, ...)
    if (this._cmdList[cmdName] ~= nil) then
        error("不能用Facade:SendMessage发送Command信息！")
    else
        --Event.Brocast(tostring(cmdName), ...)
        EventTrigger(cmdName,...)
        --Event.Brocast(tostring(cmdName), cmdName, ...) --用于标准BaseMediator的switch分类投递。
    end
end


---SendNotification 主要在自动生成的net_cmd下进行调用。因为自动生成的代码不知道到底是cmd还是mediator在接收处理。
---@param cmdName string
function Facade.SendNotification(cmdName, ...)
    EventTrigger(cmdName,...)
--    if (this._cmdList[cmdName] ~= nil) then
--        Event.Brocast(tostring(cmdName), ...)
--    else
--        Event.Brocast(tostring(cmdName), cmdName, ...)
--    end
end


---RegisterCommand
---@param cmdName string @Controller 命令名称，定义在notif_enum.lua
---@param cmdFunc fun(any:any):void
function Facade.RegisterCommand (cmdName, cmdFunc)
    --lxt("注册命令RegisterCommand ", cmdName)
    this._cmdList[cmdName] = cmdName
    RegTrigger(cmdName, cmdFunc)
    --Event.AddListener(cmdName, cmdFunc)
end

---RemoveCommand
---@param cmdName string @Controller 命令名称, 定义在notif_enum.lua
function Facade.RemoveCommand (cmdName)
    UnRegTrigger(cmdName)
    --Event.RemoveListener(cmdName)
    this._cmdList[cmdName] = nil
end

---RegisterUI
---@param mediatorClass IMediator
function Facade.RegisterUI(customId, mediatorClass)
    return this._mediatorMgr.RegisterIns(customId, mediatorClass)
end

---CreateUI
---@param mediatorClass CBaseUIMediator
function Facade.CreateUI(mediatorClass)
    return this._mediatorMgr.AutoRegisterMediator(mediatorClass)
end

---RemoveUI
---@param customId string @mediator的唯一标识。通过
function Facade.RemoveUI(customId)
    this._mediatorMgr.RemoveMediator(customId)
end

---RegisterProxy    注册Proxy
---@param  proxyIns IProxy
function Facade.RegisterProxy(proxyIns)
    this._proxyMgr.RegisterProxy(proxyIns)
end

---RemoveProxy    销毁Remove an IProxy instance from the Model.
---@param name string
function Facade.RemoveProxy(name)
    this._proxyMgr.RemoveProxy(name)
end

---RetrieveProxy    获得Retrieve an IProxy instance from the Model.
---@param name string
---@return IProxy
function Facade.RetrieveProxy(name)
    return this._proxyMgr.RetrieveProxy(name)
end

function Facade.ClearUI()
    this._mediatorMgr:Clear()
end

--TODO:以下函数不再使用
--Facade.RegisterMediator = function(self, mediator)
--    local _tempNotics = mediator.NotificationInterests();
--    for i = 1, #_tempNotics do
--        Event.AddListener(_tempNotics[i], mediator.HandleNotification);
--    end
--    --self._mediatorList[] --这里还要考虑记录此mediator对象。
--end
--
--Facade.RemoveMediator = function(self, mediator)
--    --local mediator = mediatorClass:New();
--    local _tempNotics = mediator.NotificationInterests();
--    for i = 1, #_tempNotics do
--        Event.RemoveListener(_tempNotics[i], mediator.HandleNotification);
--    end
--    --self._mediatorList[] --这里还要考虑销毁此mediator对象。
--end
