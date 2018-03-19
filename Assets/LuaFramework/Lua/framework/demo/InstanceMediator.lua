--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: InstanceMediator.lua
-- Author: Lorry  created: 2018/3/3  16：09
--[[Description: 这里实现的是一个单例的，或者说静态的Mediator，主要是代码更简洁。
不用总是传self，在OnRegister的时候编写更简单。不过这个类继续继承会有问题(不能使用不传入self的函数)
且不允许有两个InstanceMediator存在，也就是说不允许传入Facade.CreateUI,只能用于Facade.RegisterUI中。
不过现在暂时没想到一定要多个Mediator的情况。TODO：如果无法把握，请参考CTipsMediator进行编码。
Mediator可发送Command，接收Message。在初始化时取得对应Proxy实例并保存其引用，避免频繁获取。
--=====================================================================]]

require("framework.demo.activity_panel")
require("framework.core.base_ui_mediator")
---@type Notif
local Notif = require("common.notif_enum")
---@type proxy_enum
local proxy_enum = require("common.proxy_enum")

--必备四大显示local 变量
---@type UnityEngine.GameObject
local gameObject
---@type UnityEngine.Transform
local transform
----@type UIPanel
local panel
----@type LuaFramework.LuaBehaviour
local behaviour

---@type CInstanceMediator
local this
---@type CLoginProxy @获取显示所需数据。mediator尽量只获得一个Proxy。
local loginProxy

---@class CInstanceMediator : CBaseUIMediator @CInstanceMediator  继承自CBaseUIMediator
---@field _show boolean @这个mediator所控制的view是否显示。
class "CInstanceMediator"(function(_ENV)
    inherit(CBaseUIMediator)
    ----------------- Constructor ----------------
    --构造函数，参数可以根据需求修改，但第一个参数必须是self
    ---@param self CInstanceMediator
    function CInstanceMediator(self, id)
        Super(self, id);
        self._name = "CInstanceMediator"
        self._show = false;
        this = self;
    end

end)

------------------- Method -------------------
---OnRegister
---@param self CInstanceMediator
function CInstanceMediator.OnRegister(self)
    self:RegEvent(Notif.OPEN_TEST, self.OpenTest)
    self:RegEvent(Notif.CLOSE_TEST, self.CloseTest)
    self:RegEvent(Notif.UPDATE_MESSAGE, self.UpdateTest)
    loginProxy = gFacade.RetrieveProxy(proxy_enum.LOGIN)
end

---@param self CInstanceMediator
function CInstanceMediator.Destroy(self)
    panelMgr:ClosePanel('ActivityDaily');
    --CBaseObject.Destroy(self);
    if gameObject ~= nil then
        GameObject.Destroy(gameObject);
        gameObject = nil
        transform =nil
        panel = nil
        behaviour = nil
    end
    loginProxy = nil
end

------------------- Start Code手动编码部分 -------------------
--@param self CInstanceMediator
---OpenTest 单例函数，只针对本地进行操作。
function CInstanceMediator.OpenTest()
    this._show = true

    if gameObject ~= nil then
        gameObject:SetActive(true)
    else
        panelMgr:CreatePanel('ActivityDaily', this.OnCreatePanel);
    end
end

function CInstanceMediator.CloseTest()
    --lxt("CInstanceMediator.CloseTest")
    this._show = false
    if gameObject ~= nil then
        gameObject:SetActive(false)
    end
end

function CInstanceMediator.UpdateTest(msg)
    --lxt("测试用Mediator监听成功", msg)
    assert(loginProxy, "proxy_enum.LOGIN的Proxy不能为空")
    if  ActivityDailyPanel.title ~= nil then
        ---@type UILabel
        local parent =ActivityDailyPanel.title:GetComponent('UILabel')
        parent.text = loginProxy:GetDesc()
    else
        --lxt("not init CInstanceMediator.UpdateTest")
    end
end

---OnCreatePanel 初始化四大显示local 变量，方便各种函数编写。
---@param obj UnityEngine.GameObject
function CInstanceMediator.OnCreatePanel(obj)
    gameObject = obj;
    transform = obj.transform;
    panel = transform:GetComponent('UIPanel');
    behaviour = transform:GetComponent('LuaBehaviour');
    --其实下面这个添加点击事件的函数，也可以封装为全局，不依赖于这个LuaBehaviour
    --但是LuaBehaviour还做了自动清除全部点击事件的操作，TODO:思考一下，这个放在mediator的基类会怎样？
    behaviour:AddClick(ActivityDailyPanel.btnOpen, this.OnClick);

    --创建资源的正确姿势
    resMgr:LoadPrefab('activitydaily', { 'PromptItem' }, this.InitPanel);
end

function CInstanceMediator.InitPanel(objs)
    panel.depth = 1;	--设置纵深--
    local parent = ActivityDailyPanel.gridParent;
    for i = 1, 5 do
        local go = newObject(objs[0]);
        go.name = 'Item'..tostring(i);
        go.transform:SetParent(parent);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.zero;
        behaviour:AddClick(go, this.OnItemClick);

        local label = go.transform:Find('Label');
        label:GetComponent('UILabel').text = tostring(i*5);
    end
    local grid = parent:GetComponent('UIGrid');
    grid:Reposition();
    grid.repositionNow = true;
    parent:GetComponent('WrapGrid'):InitGrid();
end

--界面创建初始化完毕

--单击事件--
---@private
function CInstanceMediator.OnClick(go)
    ActivityDailyPanel.msg:GetComponent('UILabel').text = "已经测试过1.5.5Btn点击";
    gFacade.SendMessage(Notif.OPEN_TIPS,"Hello world!");
end

--滚动项单击--
---@private
function CInstanceMediator.OnItemClick(go)
    ActivityDailyPanel.title:GetComponent('UILabel').text = "点中了"..go.name;
    --lxt(go.name);
    --gFacade.SendNotification(Notif.UPDATE_MESSAGE,go.name);
end
