local transform;
local gameObject;
---@class ActivityDailyPanel
---@field btnOpen UnityEngine.GameObject
---@field gridParent UnityEngine.Transform
---@field title UnityEngine.Transform
---@field msg UnityEngine.Transform
ActivityDailyPanel = {};
local this = ActivityDailyPanel;

--启动事件--
function ActivityDailyPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
end

--初始化面板成员--
function ActivityDailyPanel.InitPanel()
	this.btnOpen = transform:Find("Open").gameObject;
	this.gridParent = transform:Find('ScrollView/Grid');
	this.title = transform:Find("txt_title");
	this.msg = transform:Find("txt_msg");
end

function ActivityDailyPanel.Start ()

end
--销毁调用函数--
function ActivityDailyPanel.OnDestroy()
	logWarn("ActivityDailyPanel.OnDestroy---->>>");
	gameObject = nil;
	transform = nil;
	this.btnOpen = nil;
	this.gridParent = nil;
	this.title = nil;
	this.msg = nil;
end
