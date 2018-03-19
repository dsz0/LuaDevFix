--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: TipsMediator.lua
-- Author: Lorry  created: 2018/3/1  19：49
--[[Description: 为了反复出现的提示框写的类。类似于MFC 的 MessageBox
    准备写成通用的标准类CStandardMediator.lua
--=====================================================================]]

--======================================================================
require("ui.common.tips_panel") --这个界面的解析文件以后需要自动生成
require("framework.core.base_ui_mediator")

local Notif = require("common.notif_enum")
---@class CTipsMediator : CBaseUIMediator @CTipsMediator  继承自CBaseUIMediator
---@field private _gameObject UnityEngine.GameObject @资源载入后实例化的GameObject
---@field public _transform UnityEngine.Transform @UI的根Transform
---@field public _panel  UIPanel @NGUI插件类，负责管理面板行为
---@field public _behaviour LuaFramework.LuaBehaviour @框架的方便类，用于直接响应引擎代码。
---@field public _msg string @提示文字内容
---@field public _show boolean @提示框是否在显示状态。
class "CTipsMediator"(function(_ENV)
    inherit(CBaseUIMediator)
    ----------------- Constructor ----------------
    --构造函数，参数可以根据需求修改，但第一个参数必须是self
    ---CTipsMediator
    ---@param self CTipsMediator
    ---@param id string @这个可以是自动生成的id，也可以是指定的枚举string
    function CTipsMediator(self, id)
        Super(self, id);
        self._gameObject = nil;
        self._transform = nil;
        self._panel = nil;
        self._behaviour = nil;
        self._show = false;
        self._msg = nil;
    end
end)

---CTipsMediator 注册消息监听函数用function() ... end 包起来，主要是为了方便传self进去。这样才是类
---只有传入了self，才是进行类对象的处理，不然就变成处理静态类或者说单例类了。不过我认为Mediator应该都可写成单例类。
---@see CMediatorManager#_RegisterMediator
---@protected @只被Mediator_Manager管理器调用
---@param self CTipsMediator
function CTipsMediator.OnRegister(self)
    --lxt(" CTipsMediator.OnRegister")
    self.RegEvent(self, Notif.OPEN_TIPS, function (msg) self:Open(msg) end)
    self.RegEvent(self, Notif.CLOSE_TIPS, function () self:Close() end)
end

---@protected @只被Mediator_Manager管理器调用
function CTipsMediator.Destroy(self)
    self:Close();
    self._gameObject = nil;
    self._transform = nil;
    self._panel = nil;
    self._behaviour = nil;
end

---Open
---@param self CTipsMediator
---@param msg string @需要显示的内容
function CTipsMediator.Open(self,msg)
    self._show = true
    self._msg = msg or "No Message"
    panelMgr:CreatePanel('Tips', function(obj)
        self.OnCreate(self, obj)
    end);
end

---Close    @关闭本界面，现在是交给panelMgr进行处理了。
---@param self CTipsMediator
function CTipsMediator.Close(self)
    self._show = false
    panelMgr:ClosePanel('Tips')
end

---OnCreate
---@param self CTipsMediator
---@param obj UnityEngine.GameObject
function CTipsMediator.OnCreate(self, obj)
    self._gameObject = obj;
    self._transform =obj.transform;
    self._panel = self._transform:GetComponent('UIPanel');
    self._panel.depth = 10; --设置深度避免遮挡错误
    self._behaviour = self._gameObject:GetComponent('LuaBehaviour');
    self._behaviour:AddClick(TipsPanel.btnClose, function(go)
        self.OnClick(self, go)
    end);
    TipsPanel.txtLabel:GetComponent("UILabel").text = self._msg;
    if self._show  == false then
        self:Close();
    end
end

---OnClick
---@param self CTipsMediator
---@param go UnityEngine.GameObject
function CTipsMediator.OnClick(self, go)
    --destroy(self._gameObject)
    self:Close();
end
