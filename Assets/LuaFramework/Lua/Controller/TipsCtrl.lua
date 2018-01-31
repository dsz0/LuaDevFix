TipsCtrl = {};
local this = TipsCtrl;

local tip;
local transform;
local gameObject;
local panel;

--构建函数--
function TipsCtrl.New()
	logWarn("TipsCtrl.New--->>");
	return this;
end

function TipsCtrl.Awake()
	logWarn("TipsCtrl.Awake--->>");
	panelMgr:CreatePanel('Tips', this.OnCreate);
end

--启动事件--
function TipsCtrl.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;

	panel = transform:GetComponent('UIPanel');
	panel.depth = 10; --设置深度避免错误的遮挡
	tip = gameObject:GetComponent('LuaBehaviour');
	tip:AddClick(TipsPanel.btnClose, this.OnClick);
	logWarn("Start lua--->>"..gameObject.name);
end

--单击事件--
function TipsCtrl.OnClick(go)
	destroy(gameObject);
end

--关闭事件--
function TipsCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Tips);
end
