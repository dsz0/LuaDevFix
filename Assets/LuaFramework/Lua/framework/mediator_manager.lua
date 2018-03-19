--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: mediator_manager.lua
-- Author: Lorry  created: 2018/3/1  16：17
--[[Description: 主要用于管理Ui的Mediator对象，是单例，由Facade持有。相当于PureMVC中的View。
通用Ui的方便函数，写在UIManager中。或者写成UICommand
--=====================================================================]]
--[[TODO:  对所有的UI仔细思考后。决定把大部分Mediator用单体的方法进行编写。
标准需要有多个实体的UI，参考TipsMediator.lua中的标准编码实现，完全按类继承实现。
单体Mediator的编写可参考（InstanceMediator.lua）简化编码实现。
游戏中，大部分的UI都是独此一份，没有必要先变为一个class，再进行由管理器来保证单例操作，
在lua中这么做实在是太傻……等于所有table都多了1~2层去调用，函数写起来也累。大部分Mediator写成单体类，编码更简洁易懂。
]]
--标准类

---@class CMediatorManager @ 主要用于管理Ui的Mediator对象
---@field _counter number @为自动生成Ui的唯一id而保存的id
CMediatorManager = {}
local this = CMediatorManager

---Instance
---@return CMediatorManager @返回CMediatorManager的单例,调用第二次会再次初始化。
function CMediatorManager.Instance ()
    this._counter = 0   --为自动生成Ui的唯一id而保存的id
    ---@type table<string, IMediator>
    this._mediatorInsList = {}
    --this._floatDialog = nil
    --this._floatMenu = nil
    --this._dlgList = {}
    -- 这里可以考虑预先载入所有的UI AB资源
    return this
end

---GetMediatorIns @通过唯一标识，获取UIMediator实体，一般使用global_enum.lua的UICustomID
---@public
---@param id string
---@return IMediator
function CMediatorManager.GetMediatorIns(id)
    return this._mediatorInsList[id]
end

-- 注册界面的Mediator
---_RegisterMediator
---@protected
---@param id string @唯一标识符，自动生成,或者指定global_enum中的UI枚举
---@param uiMediatorClass IMediator
function CMediatorManager._RegisterMediator (id, uiMediatorClass)
    assert(uiMediatorClass ~= nil, id)
    --parentTran = parentTran or self._uiMainCanvasObj.transform
    local tempMediatorIns = uiMediatorClass(id)
    this._mediatorInsList[id] = tempMediatorIns
    -- 确保Init之后调用的(考虑保证资源已加载再通知，如果在MediatorClass中做加载其实没问题)
    tempMediatorIns:OnRegister()
    --调用此函数才能将其子对象也全部打开，现在全部交给Mediator自己处理，监听对应Notif即可
    --tempMediatorIns:ShowSwitch(true)
    return tempMediatorIns
end

---AutoRegisterMediator  创造一个有多份拷贝的Mediator，自动生成唯一ID
---@param uiMediatorClass IMediator
---@return CBaseUIMediator
function CMediatorManager.AutoRegisterMediator (uiMediatorClass)
    local insID = this:_GenerateId()
    local tempMediatorIns = this._RegisterMediator(tostring(insID), uiMediatorClass)
    return tempMediatorIns
end

---RegisterIns 获得或者说注册是全局唯一的Mediator,可以通过customId获得实体
---@param customId string |UICustomID@在global_enum.lua的UICustomID中定义，避免重复
---@param uiMediatorClass IMediator
---@return CBaseUIMediator
function CMediatorManager.RegisterIns(customId, uiMediatorClass)
    local tempMediatorIns = this.GetMediatorIns(customId)
    if tempMediatorIns then
        --tempMediatorIns:ShowSwitch(true)
        return tempMediatorIns
    else
        tempMediatorIns = this._RegisterMediator(customId, uiMediatorClass)
        return tempMediatorIns
    end
end

---RemoveMediator 注销指定Mediator，移除其所有监听，调用其资源销毁函数Destory。
---@param customId string @Mediator唯一ID 标识符
function CMediatorManager.RemoveMediator(customId)
    local tempMediatorIns = this.GetMediatorIns(customId)
    assert(tempMediatorIns ~= nil, customId)
    -- 在MediatorManager去除这个tempMediatorIns
    tempMediatorIns:OnRemove()
    tempMediatorIns:Destroy()
    this._mediatorInsList[customId] = nil
end

---@see Facade#Instance
---@public
function CMediatorManager.Destroy (self)
    --GameObject.Destroy(self._uiRootObj) --现在uiRootObj在场景中，不由MediatorManager创建
    self:Clear()
end

---@private
function CMediatorManager._GenerateId (self)
    self._counter = self._counter + 1
    return self._counter
end

---Clear 依次清理所有界面
---@public
---@param self CMediatorManager
function CMediatorManager.Clear(self)
    lxt("Start CMediatorManager.Clear")
    for k, v in pairs(self._mediatorInsList) do
        if v then
            lxt(k,"On Mediator Clear")
            --print(v)
            v:OnRemove()
            v:Destroy()
        end
    end
    self._mediatorInsList = {}

    --清理缓存的所有dlg
    --for k, v in pairs(self._dlgList) do
    --    if v then
    --        v:Destroy()
    --    end
    --end
    --self._dlgList = {}
    -- --清理弹出菜单
    -- if self._floatMenu then
    -- 	self._floatMenu:Destroy()
    -- 	self._floatMenu = nil
    -- end
    -- --清理漂字(对话框)单体。( 在界面正中，不停向上推动的提示文字tips）
    -- if self._floatDialog then
    -- 	self._floatDialog:Destroy()
    -- 	self._floatDialog = nil
    -- end
    self._counter = 0
end
