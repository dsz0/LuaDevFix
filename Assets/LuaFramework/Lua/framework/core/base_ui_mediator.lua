--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: base_ui_mediator.lua
-- Author: pc  created: 2018/2/28
-- Description: Mediator可发送Command，接收Message。在初始化时取得对应Proxy实例并保存其引用，避免频繁获取。
--======================================================================
--_ENV = Module        "UI"                "v1.0.0"
--======================================================================
require("framework.core.base_object")
require("framework.interface.IMediator")

---@class CBaseUIMediator  : CBaseObject @UI中介，基础模块，用于逻辑解耦
---@field public _id  string @标记类中有一个_id属性，代码提示中会出现。
class "CBaseUIMediator" (function(_ENV)
    inherit (CBaseObject)
    --extend(IMediator)
    --构造函数
    --__Arguments__{ System.String }
    --function CBaseUIMediator(self, id)
    --    Super(self);
    --    self._id = id
    --end
    --__Arguments__{ System.Number }
    ---CBaseUIMediator 构造函数，使用不同参数会调用不同构造函数
    ---@param id number|string
    function CBaseUIMediator(self, id)
        Super(self);
        if type(id) == "string" then
            self._id = id
        else
            self._id =tostring(id)
        end
    end

end)

---GetId
---@return string
function CBaseUIMediator.GetId(self)
    return self._id
end

---OnRegister
---@param self CBaseUIMediator
function CBaseUIMediator.OnRegister(self)
    print("CBaseUIMediator -->OnRegister")
    self:RegEvent("BaseUITest", CBaseUIMediator._printName)
end

function CBaseUIMediator._printName(self)
    print("CBaseUIMediator -->test")
end