local transform;
local gameObject;

ActivityDailyPanel = {};
local this = ActivityDailyPanel;

--启动事件--
function ActivityDailyPanel.Awake(obj)
	logWarn("ActivityDailyPanel.Awake");
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板成员--
function ActivityDailyPanel.InitPanel()
	this.btnOpen = transform:Find("Open").gameObject;
	this.gridParent = transform:Find('ScrollView/Grid');
	this.title = transform:Find("txt_title");
	this.msg = transform:Find("txt_msg");
end

--销毁调用函数--
function ActivityDailyPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end
