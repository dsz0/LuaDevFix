--Panel类型的--
local transform;
local gameObject;

TipsPanel = {};
local this = TipsPanel;

--启动事件--
function TipsPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function TipsPanel.InitPanel()
	this.btnClose = transform:FindChild("Button").gameObject;
end

--单击事件--
function TipsPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end
