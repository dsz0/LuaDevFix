--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- filename: base_mediator.lua
-- author: lorry  created: 2018/02/22
-- Description: 所有的mediator都继承CBaseMediator(lua实现继承),负责模块事件的注册派发。
-- Mediator可发送Command，接收Message。在初始化时取得对应Proxy实例并保存其引用，避免频繁获取。
-- 因为UI的特殊性，所以为UI实现了已给BaseUIMediator的基类，UI相关的都继承那个就可以了。
-- TODO:暂时没有什么需要继承这个基类，现在除了UI没有其他需要在Lua中编写,有需要再完善。
--======================================================================
--[[mediator:模块解耦中介]]
--引入枚举值，进行消息注册。
--local Notif = require("common.notif_enum")
---@class CBaseMediator
class "CBaseMediator"(function(_ENV)
    --构造方法,注意将所有用到的成员变量列出并初始化。
    function CBaseMediator(self)
        self._Name = "NewBie(CBaseMediator)"
    end
end)

---NotificationInterests 子类重写:监听事件,感兴趣的通知 ,List the INotification names this Mediator is interested in being notified of
---@param self CBaseMediator
function CBaseMediator.NotificationInterests(self)
    return {}
end

---HandleNotification 子类重写:监督事件处理
---@param self CBaseMediator
---@param evt string @gFacade发过来的message定义
---@param param any @附带参数vo,当然也可能是空
function CBaseMediator.HandleNotification(self, evt, param)

end

---OnRegister -- Called by the Facade(View) when the Mediator is registered
---@param self CBaseMediator
function CBaseMediator.OnRegister(self)
end

---OnRemove -- Called by the Facade(View) when the Mediator is remove
---@param self CBaseMediator
function CBaseMediator.OnRemove(self)
end

--注册监听,暂时不用
function CBaseMediator._RegisterNotifications(self)
    gFacade.RegisterMediator(self);
    -- self._Notics = self.NotificationInterests();
    -- for i=1,table.getn(self._Notics) do
    --   gFacade.RegisterMessages(_Notics[i],_Evevnts)
    -- end
end

--移除监听，暂时不用
function CBaseMediator._RemoveAllNotifications(self)
    gFacade.RemoveMediator(self);
end

--销毁，统一使用Destroy
function CBaseMediator.Destroy(self)
    self:_RemoveAllNotifications()
    --self._Notics = nil
end
