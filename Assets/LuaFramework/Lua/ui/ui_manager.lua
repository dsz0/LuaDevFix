--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: ui_manager.lua
-- Author: lxt created: 2018/02/24
-- Description: 管理所有的ui对象，可以提炼出view基类。比view管理基类多一些通用UI直接打开函数。
-- 这里也依赖于C#中的PanelManager管理类。
--======================================================================
--[[TODO:  对所有的UI仔细思考后。决定把ui单独出来一部分操作，作为UIManager。分离UI和Mediator
这里负责几个简单的常用窗口调用。若有需要窗口回退效果的堆栈，也写在这里。尽量简化Command和Mediator的逻辑。
]]

---@class CUIManager @用于统一管理所有的界面，是一个集合的Command类
---@field private _floatDialog CFloatDialog @弹出漂字单体对象
---@field private _floatMenu CFloatMenu @弹出菜单单体对象
---@field private _dlgList table<string, IMediator>@所有对话框对象
CUIManager = {}
local this = CUIManager

---Instance
---@return CUIManager @返回CUIManager的单例
function CUIManager.Instance ()
	this._floatDialog = nil
	this._floatMenu = nil
	this._dlgList = {}
  -- 这里考虑预先载入所有的UI资源，做一个命中缓存。
	return this
end

---CreateWindow
---@param id string @唯一标识符，自动生成,或者指定global_enum
---@param uiMediatorClass IMediator
---@param parentTran UnityEngine.Transform @这个参数以后应该不用了
function CUIManager.CreateTips(msg)
	return
end

---AutoCreateWindow  创造一个有多份拷贝的Mediator
---@param uiMediatorClass IMediator
function CUIManager.MessageBox(content, msg)
	local LogicIns = nil;
	return LogicIns
end
