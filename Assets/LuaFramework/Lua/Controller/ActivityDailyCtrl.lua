require "Common/define"

ActivityDailyCtrl = {};
local this = ActivityDailyCtrl;

local panel;
local prompt;
local gameObject;
local transform;

--构建函数--
function ActivityDailyCtrl.New()
	logWarn("ActivityDailyCtrl.New--->>");
	return this;
end

function ActivityDailyCtrl.Awake()
	logWarn("ActivityDailyCtrl.Awake--->>");
	panelMgr:CreatePanel('ActivityDaily', this.OnCreate);
end

--启动事件--
function ActivityDailyCtrl.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;

	panel = transform:GetComponent('UIPanel');
	prompt = transform:GetComponent('LuaBehaviour');
	logWarn("Start lua ActivityDailyCtrl.OnCreate--->>"..gameObject.name);
  logWarn(ActivityDailyPanel.btnOpen.name)
	prompt:AddClick(ActivityDailyPanel.btnOpen, this.OnClick);
	resMgr:LoadPrefab('activitydaily', { 'PromptItem' }, this.InitPanel);
end

--初始化面板--
function ActivityDailyCtrl.InitPanel(objs)
  panel.depth = 1;	--设置纵深--
	local parent = ActivityDailyPanel.gridParent;
	for i = 1, 100 do
		local go = newObject(objs[0]);
		go.name = 'Item'..tostring(i);
		go.transform:SetParent(parent);
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3.zero;
    prompt:AddClick(go, this.OnItemClick);

    local label = go.transform:Find('Label');
    label:GetComponent('UILabel').text = tostring(i);
	end
  local grid = parent:GetComponent('UIGrid');
	grid:Reposition();
	grid.repositionNow = true;
	parent:GetComponent('WrapGrid'):InitGrid();
end

--关闭事件--
function ActivityDailyCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Prompt);
end

--滚动项单击--
function ActivityDailyCtrl.OnItemClick(go)
    log(go.name);
end

--单击事件--
function ActivityDailyCtrl.OnClick(go)
  logWarn("OnClick---->>>"..go.name);
	local ctrl = CtrlManager.GetCtrl(CtrlNames.Tips);
	if ctrl ~= nil then
			ctrl:Awake();
	end
end
